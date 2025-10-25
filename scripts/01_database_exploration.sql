SELECT
YEAR(order_date) AS order_year,
SUM(sales_amount) AS total_sale
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)


SELECT
YEAR(order_date) AS order_year,
SUM(sales_amount) AS total_sale,
COUNT(DISTINCT customer_key) as total_customer
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

SELECT
YEAR(order_date) AS order_year,
SUM(sales_amount) AS total_sale,
COUNT(DISTINCT customer_key) as total_customer,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

SELECT
MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_sale,
COUNT(DISTINCT customer_key) as total_customer,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)

SELECT
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_sale,
COUNT(DISTINCT customer_key) as total_customer,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)

SELECT
DATETRUNC(month, order_date) AS order_date,
SUM(sales_amount) AS total_sale,
COUNT(DISTINCT customer_key) AS total_customer,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)