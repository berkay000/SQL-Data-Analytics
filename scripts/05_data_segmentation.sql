/*Segment products into cost ranges and count how many products fall into each segment*/
with product_segment as (
SELECT
product_key,
product_name,
cost,
case when cost < 100 then 'Below 100'
    when cost between 100 and 500 then '100-500'
    when cost between 500 and 1000 then '500-1000'
    else 'Above 1000'
    end cost_range
From gold.dim_products
)
select 
cost_range,
count(product_key) as total_products
from product_segment
GROUP BY cost_range
order by total_products desc




/*Group customers into three segments based on their spending behavior:
VIP: Customers with at least 12 months of history and spending more than €5,000.
Regular: Customers with at least 12 months of history but spending €5,000 or less.
New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

--step 1
--calculate customer lifespan and total spending
begin
select
c.customer_key,
MIN(f.order_date) as first_order,
MAX(f.order_date) as last_order,
sum(f.sales_amount) as total_spending,
DATEDIFF(month, MIN(f.order_date), MAX(f.order_date)) as lifespan
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
where f.customer_key is not null
GROUP BY c.customer_key
end


--step 2
--segment customers
BEGIN
with customer_spending as (
    select
    c.customer_key,
    MIN(f.order_date) as first_order,
    MAX(f.order_date) as last_order,
    sum(f.sales_amount) as total_spending,
    DATEDIFF(month, MIN(f.order_date), MAX(f.order_date)) as lifespan
    from gold.fact_sales f
    left join gold.dim_customers c
    on c.customer_key = f.customer_key
    where f.customer_key is not null
    GROUP BY c.customer_key
)
SELECT
customer_key,
case when lifespan >= 12 and total_spending > 5000 then 'VIP'
    when lifespan >= 12 and total_spending <= 5000 then 'Regular'
    else 'New'
END as customer_segment
from customer_spending
END


--step 3
--Find total number of customers by each segment
BEGIN
with customer_spending as (
    select
    c.customer_key,
    MIN(f.order_date) as first_order,
    MAX(f.order_date) as last_order,
    sum(f.sales_amount) as total_spending,
    DATEDIFF(month, MIN(f.order_date), MAX(f.order_date)) as lifespan
    from gold.fact_sales f
    left join gold.dim_customers c
    on c.customer_key = f.customer_key
    where f.customer_key is not null
    GROUP BY c.customer_key
)
SELECT
customer_segment,
COUNT(customer_key) as total_customers
FROM 
(
    SELECT
    customer_key,
    case when lifespan >= 12 and total_spending > 5000 then 'VIP'
        when lifespan >= 12 and total_spending <= 5000 then 'Regular'
        else 'New'
    END customer_segment
    from customer_spending
) t
GROUP BY(customer_segment)
order by total_customers desc
END
