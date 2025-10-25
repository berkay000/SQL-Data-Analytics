--Which categories contribute most to overall sales?

with category_sales as (
SELECT
p.category,
sum(f.sales_amount) as total_sales
From gold.fact_sales f
LEFT JOIN gold.dim_products p
on f.product_key = p.product_key
WHERE order_date IS NOT NULL
group by p.category
)
SELECT
category,
total_sales,
sum(total_sales) over() as overall_sales,
CONCAT(ROUND((CAST(total_sales as float) / sum(total_sales) over()) * 100, 2), '%') as sales_percentage
from category_sales
ORDER BY total_sales DESC