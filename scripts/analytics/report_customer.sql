/*
===========================================================================
Customer Report
===========================================================================
Purpose: This report consolidates key customer metrics and behaviors

Processes:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regelar, New) and age groups
	3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (months)
	4. Calculates valuable KPIs
	   - recency (months since last order)
	   - average order value
	   - average monthly spend

===========================================================================
*/


IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS
WITH base_query as (
SELECT f.order_number,
	   f.product_key,
	   f.order_date,
	   f.sales_amount,
	   f.quantity,
	   c.customer_key,
	   c.customer_number,
	   CONCAT(c.first_name,' ',c.last_name) as customer_name,
	   DATEDIFF(year,c.birth_date,GETDATE()) as age
FROM gold.fact_sales as f
LEFT JOIN gold.dim_customers as c ON f.customer_key = c.customer_key
WHERE f.order_date IS NOT NULL),

customer_aggregation as(
SELECT customer_key,
	   customer_number,
	   customer_name,
	   age,
	   COUNT(DISTINCT order_number) as total_orders,
	   SUM(sales_amount) as total_sales,
	   SUM(quantity) AS total_quantity,
	   COUNT(DISTINCT product_key) as total_products,
	   MAX(order_date) as last_order_date,
	   DATEDIFF(month,MIN(order_date),MAX(order_date)) as lifespan
FROM base_query
GROUP BY customer_key, customer_number, customer_name, age
 )

SELECT customer_key,
	   customer_number,
	   customer_name,
	   age,
	   CASE WHEN age < 20 THEN 'Under 20'
			WHEN age between 20 and 29 THEN '20-29'
			WHEN age between 30 and 39 THEN '30-39'
			WHEN age between 40 and 49 THEN '40-49'
			ELSE '50 or above'
	   END AS age_group,
	   CASE WHEN total_sales > 5000 AND  lifespan >= 12 THEN 'VIP'
	        WHEN total_sales <= 5000 AND  lifespan >= 12 THEN 'Regular'
			ELSE 'New'
	   END AS customer_tier,
	   last_order_date,
	   DATEDIFF(month,last_order_date,GETDATE()) as recency,
	   total_orders,
	   total_sales,
	   total_products,
	   total_quantity,
	   lifespan,
	   -- Compute average order value
	   CASE WHEN total_orders != 0 THEN total_sales / total_orders
			ELSE 0
	   END AS avg_order_value,
	   CASE WHEN lifespan != 0 THEN total_sales / lifespan
			ELSE 0
	   END AS avg_monthly_spend
FROM customer_aggregation