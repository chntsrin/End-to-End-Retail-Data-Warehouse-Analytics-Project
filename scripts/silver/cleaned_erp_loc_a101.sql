-- Clean bronze.erp_loc_a101

SELECT *
FROM bronze.erp_loc_a101


-- Check primary key (cid)
SELECT REPLACE(cid,'-','') as cid
FROM bronze.erp_loc_a101
WHERE REPLACE(cid,'-','') NOT IN (SELECT cst_key FROM silver.crm_cust_info)


-- Check country
SELECT DISTINCT CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
			WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
			ELSE TRIM(cntry)
			END AS cntry
FROM bronze.erp_loc_a101

-- Cleaned query
SELECT REPLACE(cid,'-','') as cid,
	   CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
			WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
			ELSE TRIM(cntry)
	   END AS cntry
FROM bronze.erp_loc_a101