--Calculate the total sales per month and the running total sales over time

SELECT
DATETRUNC(MONTH, order_date) AS order_date,
SUM(sales_amount) AS total_sales,
AVG(price) as average_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date)


--CUMULATIVE TOTAL SALES OVER TIME
SELECT
order_date,
total_sales,
SUM(total_sales) over (order by order_date) as running_total_sale,
average_price,
avg(average_price) over (order by order_date) as running_average_price
FROM
(
    SELECT
    DATETRUNC(MONTH, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    AVG(price) as average_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
) T


--CUMULATIVE TOTAL SALES OVER TIME, resetting each year
SELECT
order_date,
total_sales,
SUM(total_sales) over (partition by year(order_date) order by order_date) as running_total_sale,
average_price,
avg(average_price) over (partition by year(order_date) order by order_date) as running_average_price
FROM
(
    SELECT
    DATETRUNC(MONTH, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    AVG(price) as average_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
) T




