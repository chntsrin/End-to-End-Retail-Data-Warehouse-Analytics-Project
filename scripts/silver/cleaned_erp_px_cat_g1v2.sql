-- Cleaned bronze.erp_px_cat_g1v2

SELECT *
FROM bronze.erp_px_cat_g1v2

-- Check primary key (id)
SELECT id
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (SELECT cat_id FROM silver.crm_prd_info)

-- Check cat column
SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2

-- Check subcat column
SELECT DISTINCT subcat
FROM bronze.erp_px_cat_g1v2
ORDER BY subcat

-- Check maintenance column
SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2

-- Cleaned query
SELECT id,
	   cat,
	   subcat,
	   maintenance
FROM bronze.erp_px_cat_g1v2

select *
from silver.erp_px_cat_g1v2

