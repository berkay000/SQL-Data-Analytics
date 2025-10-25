/* Analyze the yearly performance of products by comparing their sales to both the average 
sales performance of the product and the prvious year's sales. */


SELECT 
year(f.order_date) as order_year,
p.product_name,
sum(f.sales_amount) as current_sales
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p 
on f.product_key = p.product_key 
WHERE order_date IS NOT NULL
GROUP BY year(f.order_date), p.product_name
order by p.product_name, year(f.order_date)



SELECT
order_year,
product_name,
current_sales,
sum(current_sales) over(partition by product_name order by order_year, product_name) as running_sales
from (
    SELECT 
    year(f.order_date) as order_year,
    p.product_name,
    sum(f.sales_amount) as current_sales
    FROM gold.fact_sales f 
    LEFT JOIN gold.dim_products p 
    on f.product_key = p.product_key 
    WHERE order_date IS NOT NULL
    GROUP BY year(f.order_date), p.product_name
) t



WITH yearly_product_sales as (
    SELECT 
    year(f.order_date) as order_year,
    p.product_name,
    sum(f.sales_amount) as current_sales
    FROM gold.fact_sales f 
    LEFT JOIN gold.dim_products p 
    on f.product_key = p.product_key 
    WHERE order_date IS NOT NULL
    GROUP BY year(f.order_date), p.product_name
)
select 
order_year,
product_name,
current_sales,
AVG(current_sales) over (PARTITION BY product_name) as avg_sales,
current_sales - AVG(current_sales) over (PARTITION BY product_name) as diff_avg,
CASE WHEN current_sales - AVG(current_sales) over (PARTITION BY product_name) > 0 THEN 'Above Avg'
     WHEN current_sales - AVG(current_sales) over (PARTITION BY product_name) < 0 THEN 'Below Avg'
     ELSE 'Avg' 
END avg_change,
LAG(current_sales) over (partition by product_name order by order_year) as previous_year_sales,
current_sales - LAG(current_sales) over (partition by product_name order by order_year) as diff_previous_year,
case when current_sales - LAG(current_sales) over (partition by product_name order by order_year) > 0 then 'Increase'
     when current_sales - LAG(current_sales) over (partition by product_name order by order_year) < 0 then 'Decrease'
     else 'No Change'
end as previous_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year





----
WITH motnhly_product_sales as (
    SELECT 
    DATETRUNC(month, f.order_date) as order_date,
    p.product_name,
    sum(f.sales_amount) as current_sales
    FROM gold.fact_sales f 
    LEFT JOIN gold.dim_products p 
    on f.product_key = p.product_key 
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, f.order_date), p.product_name
)
select 
order_date,
product_name,
current_sales,
AVG(current_sales) over (PARTITION BY product_name) as avg_sales,
current_sales - AVG(current_sales) over (PARTITION BY product_name) as diff_avg,
CASE WHEN current_sales - AVG(current_sales) over (PARTITION BY product_name) > 0 THEN 'Above Avg'
     WHEN current_sales - AVG(current_sales) over (PARTITION BY product_name) < 0 THEN 'Below Avg'
     ELSE 'Avg' 
END avg_change,
LAG(current_sales) over (partition by product_name order by order_date) as previous_month_sales,
current_sales - LAG(current_sales) over (partition by product_name order by order_date) as diff_previous_month,
case when current_sales - LAG(current_sales) over (partition by product_name order by order_date) > 0 then 'Increase'
     when current_sales - LAG(current_sales) over (partition by product_name order by order_date) < 0 then 'Decrease'
     else 'No Change'
end as previous_month_change
FROM motnhly_product_sales
ORDER BY product_name, order_date