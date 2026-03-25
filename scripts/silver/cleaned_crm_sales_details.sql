-- Clean bronze.crm_sales_details

SELECT *
FROM bronze.crm_sales_details

-- check null values from primary key (sls_ord_num)
-- cleared
SELECT *
FROM bronze.crm_sales_details
WHERE sls_ord_num IS NULL

-- check values that not in cst_id and prd_key
--cleared
SELECT *
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

-- check negative values in sales, quantity, price
-- sls_sales -> 3 negatives
-- sls_quantity -> cleared
-- sls_price -> 5 negatives
SELECT sls_price
FROM bronze.crm_sales_details
where sls_price < 0


-- Cast order,ship, due date to DATE type
SELECT NULLIF(sls_order_dt,0) as sls_order_dt
FROM bronze.crm_sales_details
where len(sls_order_dt) != 8

-- Order Date should arrive before Ship date
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Check sales = quantity x price
SELECT sls_sales as old_sls_sales, sls_quantity as old_sls_quantity, sls_price as old_sls_price,
		CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
			END AS sls_sales,
		sls_quantity,
		CASE WHEN sls_price = 0 OR sls_price IS NULL THEN sls_sales/NULLIF(sls_quantity,0)
			 WHEN sls_price < 0 THEN ABS(sls_price)
			 ELSE sls_price
			 END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0


-- Cleaned query
SELECT sls_ord_num,
	   sls_prd_key,
	   sls_cust_id,
	   CASE WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
		    ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
	   END AS sls_order_dt,
	   CASE WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
		    ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
	   END AS sls_ship_dt,
	   CASE WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
	        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
	   END AS sls_due_dt,
	   CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
	   END AS sls_sales,
	   sls_quantity,
	   CASE WHEN sls_price = 0 OR sls_price IS NULL THEN sls_sales/NULLIF(sls_quantity,0)
			WHEN sls_price < 0 THEN ABS(sls_price)
			ELSE sls_price
	   END AS sls_price
FROM bronze.crm_sales_details



