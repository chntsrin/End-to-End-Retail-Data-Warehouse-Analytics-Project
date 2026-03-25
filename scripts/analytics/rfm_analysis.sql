/*
===============================================================================
RFM Analysis: Customer Segmentation
===============================================================================
Purpose: 
- Segment customers based on purchasing behavior to identify high-value tiers
- Specifically filters for "Champion" customers (R=5, F=5, M=5)

R -> Recency (When was the customer's last purchase (in months))
F -> Frequency (How often does the customer buy the products)
M -> Monetary (Total revenue from each customer)

===============================================================================
*/


WITH cte_rfm AS(
SELECT c.customer_key,
	   c.first_name,
	   c.last_name,
	   MAX(f.order_date) as recent_order,
	   DATEDIFF(month,MAX(f.order_date),GETDATE()) as recent_month,
	   COUNT(*) as total_order,
	   SUM(f.sales_amount) as total_sales,
	   NTILE(5) OVER(ORDER BY DATEDIFF(month,MAX(f.order_date),GETDATE()) DESC) as R_score,
	   NTILE(5) OVER(ORDER BY  COUNT(*)) as F_score,
	   NTILE(5) OVER(ORDER BY SUM(f.sales_amount)) as M_score
FROM gold.fact_sales as f
LEFT JOIN gold.dim_customers as c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name)

SELECT *
FROM cte_rfm
WHERE R_score = 5 and F_score = 5 and M_score = 5
ORDER BY customer_key