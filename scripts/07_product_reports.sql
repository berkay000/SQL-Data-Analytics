/*
 --------------
 Product Report
 --------------
 Purpose:
 - This report consolidates key product metrics and behaviors.
 Highlights:
 1. Gathers essential fields such as product name, category, subcategory, and cost.
 2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
 3. Aggregates product-level metrics:
 - total orders
 - total sales
 - total quantity sold
 - total customers (unique)
 - lifespan (in months)
 4.Calculates valuable KPIs:
 - recency (months since last sale)
 - average order revenue (AOR)
 - average monthly revenue
 */
GO
create VIEW gold.report_products as
with base_query as (
    select 
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        f.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost,
        f.price
    from gold.fact_sales f
        left join gold.dim_products p on f.product_key = p.product_key
    where f.order_date is not null
),
product_aggregations as (
    SELECT 
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        price,
        price - cost as profit,
        max(order_date) as last_sale_date,
        count(product_key) as total_orders,
        sum(sales_amount) as total_sales,
        sum(quantity) as total_quantity,
        count(distinct customer_key) as total_customers,
        datediff(month, min(order_date), max(order_date)) as lifespan
    from base_query
    group by product_key,
        product_name,
        category,
        subcategory,
        cost,
        price
)
SELECT
    product_key, 
    product_name,
    category,
    subcategory,
    cost,
    price,
    profit * total_quantity as total_profit,
    CASE
        when total_sales > 50000 then 'High-Performer'
        when total_sales > 10000 then 'Mid-Range'
        else 'Low-Performer'
    end as product_segment,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    CASE
        when total_orders = 0 then 0
        else total_sales / total_orders
    end as avg_order_revenue,
    CASE
        when lifespan = 0 then total_sales
        else total_sales / lifespan
    end as avg_monthly_revenue
from product_aggregations
go


SELECT
subcategory,
sum(total_orders) as total_orders,
sum(total_quantity) total_quantity,
sum(total_sales) as total_sales,
sum(total_profit) as total_profit
from gold.report_products
group by subcategory
order by total_profit desc