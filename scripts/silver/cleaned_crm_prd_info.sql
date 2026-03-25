-- Cleaned bronze.crm_prd_info

SELECT *
FROM bronze.crm_prd_info

-- Check null and duplicate values
-- prd_id cleared
-- prd_key cleared
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING count(*) > 1 OR prd_id IS NULL

-- Check Unwanted space
-- Cleared
SELECT *
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Clean prd_cost
-- Check null or negative numbers
select prd_cost
FROM bronze.crm_prd_info
where prd_cost IS NULL OR prd_cost < 0

-- Clean prd_line
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info


-- Clean prd_start_dt, prd_end_dt
select *
from silver.crm_prd_info
where prd_end_dt < prd_start_dt


-- Cleaned query
SELECT prd_id,
	   REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
	   SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key,
	   prd_nm,
	   ISNULL(prd_cost,0) as prd_cost,
	   CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
			WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
			WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
			ELSE 'n/a'
			END AS prd_line,
	   CAST(prd_start_dt AS DATE),
	   CAST(DATEADD(day,-1,LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)) AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info

