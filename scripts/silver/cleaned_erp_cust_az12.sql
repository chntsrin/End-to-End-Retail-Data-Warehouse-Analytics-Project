-- Clean bronze.erp_cust_az12

SELECT *
FROM bronze.erp_cust_az12

-- Check primary key (cid)
SELECT REPLACE(cid,'NAS','') as cid
FROM bronze.erp_cust_az12
WHERE REPLACE(cid,'NAS','') NOT IN (SELECT cst_key FROM silver.crm_cust_info)

-- Check bdate > today
SELECT bdate
FROM bronze.erp_cust_az12
WHERE bdate >= GETDATE()

-- Check gender
SELECT DISTINCT gen
FROM bronze.erp_cust_az12


-- Cleaned Query
SELECT REPLACE(cid,'NAS','') as cid,
	   CASE WHEN bdate > GETDATE() THEN NULL
		    ELSE bdate
	   END AS bdate,
	   CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(gen)) IN ('M','Male') THEN 'Male'
			ELSE 'n/a'
	   END AS gen
FROM bronze.erp_cust_az12