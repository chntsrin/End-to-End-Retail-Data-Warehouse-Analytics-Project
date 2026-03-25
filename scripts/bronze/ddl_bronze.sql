/*
========================================================================================================================
DDL Script: Create Bronze table
========================================================================================================================
Script Purpose:
Check if Bronze tables are already exist or not, if they already exist then drop tables and create new Bronze tables
*/

-- Create brozne.crm_cust_info
IF OBJECT_ID('bronze.crm_cust_info','u') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info(
cst_id INT,
cst_key VARCHAR(50),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_marital VARCHAR(20),
cst_gender VARCHAR(10),
cst_create_date DATE);
GO


-- Create brozne.prd_info
IF OBJECT_ID('bronze.crm_prd_info','u') IS NOT NULL
	DROP TABLE bronze.crm_prd_info

CREATE TABLE bronze.crm_prd_info(
prd_id INT,
prd_key VARCHAR(50),
prd_nm VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE);
GO


-- Create brozne.crm_sales_details
IF OBJECT_ID('bronze.crm_sales_details','u') IS NOT NULL
	DROP TABLE bronze.crm_sales_details

CREATE TABLE bronze.crm_sales_details(
sls_ord_num VARCHAR(50),
sls_prd_key VARCHAR(50),
sls_cust_id VARCHAR(50),
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT);
GO


-- Create brozne.erp_cust_az12
IF OBJECT_ID('bronze.erp_cust_az12','u') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12

CREATE TABLE bronze.erp_cust_az12(
cid VARCHAR(50),
bdate DATE,
gen varchar(50));
GO


-- Create brozne.erp_loc_a101
IF OBJECT_ID('bronze.erp_loc_a101','u') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101

CREATE TABLE bronze.erp_loc_a101(
cid VARCHAR(50),
cntry VARCHAR(50));
GO


-- Create brozne.erp_px_cat_g1v2
IF OBJECT_ID('bronze.erp_px_cat_g1v2','u') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2

CREATE TABLE bronze.erp_px_cat_g1v2(
id VARCHAR(50),
cat VARCHAR(50),
subcat VARCHAR(50),
maintenance VARCHAR(50));


