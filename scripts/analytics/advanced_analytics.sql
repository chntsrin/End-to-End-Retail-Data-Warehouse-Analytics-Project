/*
========================================================================================================================
Advance Analytics
========================================================================================================================
Script Purpose:
 1) Time-series Analysis
 2) Cumulative Analysis
 3) Performance Analysis
 4) Part to Whole
 5) Data Segmentation
*/


-- Time-series Analysis
-- Analyse sales performance over time
SELECT MONTH(order_date) as date_month,
	   YEAR(order_date) as date_year,
	   SUM(sales_amount) as total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date) , YEAR(order_date)
ORDER BY date_year, date_month


-- Cumulatives Analysis
-- Calculate total sales per month
SELECT order_date,
	   total_sales,
	   SUM(total_sales) OVER(PARTITION BY year(order_date) ORDER BY order_date) as running_total_sales
FROM
(SELECT DATETRUNC(month,order_date) as order_date,
	   SUM(sales_amount) as total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)) as t


-- Performance Analysis
-- Analyze the year performance of products by comparing their sales 
WITH yearly_product_sales as(
SELECT YEAR(f.order_date) as order_year,
	   p.product_name,
	   SUM(f.sales_amount) as current_sales
FROM gold.fact_sales as f
LEFT JOIN gold.dim_products as p ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY  YEAR(f.order_date), p.product_name
)

SELECT order_year,
	   product_name,
	   current_sales,
	   AVG(current_sales) OVER(PARTITION BY product_name) as avg_sales,
	   current_sales - AVG(current_sales) OVER(PARTITION BY product_name) as diff_avg,
	   LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) as previous_sales,
	   current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) as diff_previous_sales
FROM yearly_product_sales
ORDER BY product_name, order_year


-- Part to Whole
SELECt category,
	   category_sales,
	   CONCAT(ROUND((CAST(category_sales AS FLOAT)/ SUM(category_sales) OVER()) * 100,2),'%') as proportion
FROM(
SELECT category,
	   SUM(sales_amount) as category_sales
FROM gold.fact_sales as f
LEFT JOIN gold.dim_products as p ON f.product_key = p.product_key
GROUP BY category) as t
ORDER BY proportion DESC


-- Data Segmentation
-- To group data into categories for targeted insights
WITH product_segment AS(
SELECT product_key,
	   product_name,
	   cost,
	   CASE WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS cost_range
FROM gold.dim_products),

customer_segment AS(
SELECT customer_key,
	   SUM(sales_amount) as total_sales,
	   DATEDIFF(month,MIN(order_date),MAX(order_date)) as total_month,
	   CASE WHEN SUM(sales_amount) > 5000 AND DATEDIFF(month,MIN(order_date),MAX(order_date)) >= 12 THEN 'VIP'
	        WHEN SUM(sales_amount) <= 5000 AND DATEDIFF(month,MIN(order_date),MAX(order_date)) >= 12 THEN 'Regular'
	   ELSE 'New'
	   END AS customer_tier
FROM gold.fact_sales
GROUP BY customer_key)

SELECT customer_tier,
	   COUNT(*) as customer_number
FROM customer_segment
GROUP BY customer_tier
ORDER BY customer_number






