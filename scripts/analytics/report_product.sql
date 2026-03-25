/*
===============================================================================
Product Report
===============================================================================
Purpose: This report consolidates key product metrics and behaviors

Processes:
    1. Gathers essential fields such as product name, category, subcategory, and cost
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/


IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS
WITH base_query AS(
	SELECT f.order_number,
		   f.customer_key,
		   f.product_key,
		   f.order_date,
		   p.product_number,
		   p.product_name,
		   p.category,
		   p.subcategory,
		   p.cost,
		   f.sales_amount,
		   f.quantity
	FROM gold.fact_sales as f
	LEFT JOIN gold.dim_products as p ON f.product_key = p.product_key
	WHERE f.order_number IS NOT NULL
),

product_aggregation AS(
	SELECT product_key,
		   product_number,
		   product_name,
		   category,
		   subcategory,
		   cost,
		   DATEDIFF(month,MIN(order_date),MAX(order_date)) as lifespan,
		   MAX(order_date) as last_sales_date,
		   COUNT(order_number) as total_orders,
		   SUM(sales_amount) as total_sales,
		   SUM(quantity) as total_quantity,
		   COUNT(DISTINCT customer_key) as total_customers,
		   ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
	FROM base_query
	GROUP BY product_key, product_number, product_name, category, subcategory, cost
)

SELECT product_key,
	   product_number,
	   product_name,
       category,
       subcategory,
	   cost,
	   last_sales_date,
	   DATEDIFF(month,last_sales_date,GETDATE()) as recency,
	   CASE WHEN total_sales > 50000 THEN 'High-Perfromer'
			WHEN total_sales >= 10000 THEN 'Mid-Range'
			ELSE 'Low-Performer'
	   END AS product_segment,
	   lifespan,
	   total_orders,
	   total_sales,
	   total_customers,
	   avg_selling_price,
	   CASE WHEN total_orders > 0 THEN total_sales / total_orders
		    ELSE 0
	   END AS avg_order_revenue,
	   CASE WHEN lifespan = 0 THEN total_sales
		    ELSE total_sales / lifespan
	   END AS avg_monthly_revenue
FROM product_aggregation