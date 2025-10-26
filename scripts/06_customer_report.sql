/*
 ---------------
 Customer Report
 ---------------
 
 Purpose:
    - This report consolidates key customer metrics and behaviors
 Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend
 
 */
-- Step 1: Extracts foundational sales and customer data for further processing.
-- Focuses on core transactional details needed for customer-level analytics.
BEGIN
SELECT 
    f.order_date,
    f.order_number,
    f.product_key,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    DATEDIFF(year, c.birthdate, getdate()) as age
from gold.fact_sales f
    left join gold.dim_customers c on f.customer_key = c.customer_key
where f.order_date is not null
END 



-- Step 2: Aggregates customer behavior into key KPIs including orders, revenue, 
-- product variety, and lifecycle metrics for analytical modeling.
BEGIN with base_query as (
    SELECT 
        f.order_date,
        f.order_number,
        f.product_key,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(year, c.birthdate, getdate()) as age
    from gold.fact_sales f
        left join gold.dim_customers c on f.customer_key = c.customer_key
    where f.order_date is not null
)
select customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(distinct order_number) as total_orders,
    sum(sales_amount) as total_sales,
    sum(quantity) as total_quantity,
    COUNT(distinct product_key) as total_products,
    max(order_date) as last_order_date,
    DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan
from base_query
group by customer_key,
    customer_number,
    customer_name,
    age
END 



-- Step 3: Enhances the customer profile with segmentation attributes such as age groups,
-- spending tiers, recency, and monthly performance to support reporting and insights.
BEGIN with base_query as (
    /*
     Base Query: Retrieves core columns from table
     */
    SELECT 
        f.order_date,
        f.order_number,
        f.product_key,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(year, c.birthdate, getdate()) as age
    from gold.fact_sales f
        left join gold.dim_customers c on f.customer_key = c.customer_key
    where f.order_date is not null
),
customer_aggregation as (
    /*
     Customer Aggregation: Summerizes key metrics at the customer level
     */
    select 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(distinct order_number) as total_orders,
        sum(sales_amount) as total_sales,
        sum(quantity) as total_quantity,
        COUNT(distinct product_key) as total_products,
        max(order_date) as last_order_date,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan
    from base_query
    group by customer_key,
        customer_number,
        customer_name,
        age
)
select 
    customer_key,
    customer_number,
    customer_name,
    age,
    case
        when age < 20 then 'Under 20'
        when age between 20 and 29 then '20-29'
        when age between 30 and 39 then '30-39'
        when age between 40 and 49 then '40-49'
        else '50 and over'
    END as age_group,
    case
        when lifespan >= 12 and total_sales > 5000 then 'VIP'
        when lifespan >= 12 and total_sales <= 5000 then 'Regular'
        else 'New'
    END as customer_segment,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,
    datediff(month, last_order_date, getdate()) as recency,
    case
        when total_orders = 0 then 0
        else total_sales / total_orders
    end average_order_value,
    case
        when lifespan = 0 then total_sales
        else total_sales / lifespan
    end as average_monthly_spend
from customer_aggregation
order by customer_key
END 



-- Step 4: Publishes the full customer analytics dataset as a centralized reporting view,
-- ensuring consistent consumption across BI and downstream data products.
GO
create or alter VIEW gold.report_customers as
    with base_query as (
        /*
         Base Query: Retrieves core columns from table
         */
        SELECT f.order_date,
            f.order_number,
            f.product_key,
            f.sales_amount,
            f.quantity,
            c.customer_key,
            c.customer_number,
            CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
            DATEDIFF(year, c.birthdate, getdate()) as age
        from gold.fact_sales f
            left join gold.dim_customers c on f.customer_key = c.customer_key
        where f.order_date is not null
    ),
    customer_aggregation as (
        /*
         Customer Aggregation: Summerizes key metrics at the customer level
         */
        select customer_key,
            customer_number,
            customer_name,
            age,
            COUNT(distinct order_number) as total_orders,
            sum(sales_amount) as total_sales,
            sum(quantity) as total_quantity,
            COUNT(distinct product_key) as total_products,
            max(order_date) as last_order_date,
            DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan
        from base_query
        group by customer_key,
            customer_number,
            customer_name,
            age
    )
    select customer_key,
        customer_number,
        customer_name,
        age,
        case
            when age < 20 then 'Under 20'
            when age between 20 and 29 then '20-29'
            when age between 30 and 39 then '30-39'
            when age between 40 and 49 then '40-49'
            else '50 and over'
        END as age_group,
        case
            when lifespan >= 12
            and total_sales > 5000 then 'VIP'
            when lifespan >= 12
            and total_sales <= 5000 then 'Regular'
            else 'New'
        END as customer_segment,
        total_orders,
        total_sales,
        total_quantity,
        total_products,
        lifespan,
        datediff(month, last_order_date, getdate()) as recency,
        case
            when total_orders = 0 then 0
            else total_sales / total_orders
        end average_order_value,
        case
            when lifespan = 0 then total_sales
            else total_sales / lifespan
        end as average_monthly_spend
    from customer_aggregation
go




select
age_group,
count(customer_number) as total_customers,
sum(total_sales) as total_sales
from gold.report_customers
group by age_group
order by total_sales desc


select
customer_segment,
count(customer_number) as total_customers,
sum(total_sales) as total_sales
from gold.report_customers
group by customer_segment
order by total_sales desc