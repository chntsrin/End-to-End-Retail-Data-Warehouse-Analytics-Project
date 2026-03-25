/*
========================================================================================================================
DDL Script: Create Gold views
========================================================================================================================
Script Purpose:
Creat views for Gold layer in data warehouse, The gold layer represents dimension and fact tables (Star Schema)
*/


-- Create gold.dim_customers view
IF OBJECT_ID('gold.dim_customers','V') IS NOT NULL
	DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT ROW_NUMBER() OVER(ORDER BY ci.cst_id) customer_key,
	   ci.cst_id as customer_id,
	   ci.cst_key as customer_number,
	   ci.cst_firstname as first_name,
	   ci.cst_lastname as last_name,
	   la.cntry as country,
	   ci.cst_marital as marital_status,
	   CASE WHEN ci.cst_gender != 'n/a' THEN ci.cst_gender -- CRM is the master of gender info
			ELSE COALESCE(ca.gen,'n/a')
	   END AS gender,
	   ca.bdate as birth_date,
	   ci.cst_create_date as  create_date
FROM silver.crm_cust_info as ci
LEFT JOIN silver.erp_cust_az12 as ca ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 as la ON ci.cst_key = la.cid;
GO


-- Create gold.dim_products view
IF OBJECT_ID('gold.dim_products','V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT ROW_NUMBER() OVER(ORDER BY pif.prd_start_dt, pif.prd_key) as product_key,
	   pif.prd_id as product_id,
	   pif.prd_key as product_number,
	   pif.prd_nm as product_name,
	   pif.cat_id as category_id,
	   pc.cat as category,
	   pc.subcat as subcategory,
	   pc.maintenance,
	   pif.prd_cost as cost,
	   pif.prd_line as product_line,
	   pif.prd_start_dt as start_date
FROM silver.crm_prd_info as pif
LEFT JOIN silver.erp_px_cat_g1v2 as pc ON pif.cat_id = pc.id
WHERE prd_end_dt IS NULL;
GO


-- Create gold.fact_sales view
IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT sd.sls_ord_num as order_number,
	   dp.product_key,
	   dc.customer_key,
	   sd.sls_order_dt as order_date,
	   sd.sls_ship_dt as shipping_date,
	   sd.sls_due_dt as due_date,
	   sd.sls_sales as sales_amount,
	   sd.sls_quantity as quantity,
	   sd.sls_price as price
FROM silver.crm_sales_details as sd
LEFT JOIN gold.dim_products as dp ON sd.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers as dc ON sd.sls_cust_id = dc.customer_id

