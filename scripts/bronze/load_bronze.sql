/*
========================================================================================================================
Load Bronze layer (Source -> Bronze)
========================================================================================================================
Script Purpose:
Truncate to clear all data in tables if it already exist and then use Bulk Insert to load data from source (csv file) to Bronze tables
*/

DECLARE @start_time DATETIME, @end_time DATETIME
SET @start_time = GETDATE();

PRINT('Loading datasets...')

-- Load crm_cust_info
PRINT('Start load cust_info.csv')
TRUNCATE TABLE bronze.crm_cust_info
BULK INSERT bronze.crm_cust_info
FROM 'C:\sql\dwh_project\datasets\cust_info.csv'
WITH (FIRSTROW = 2,
	  FIELDTERMINATOR = ',',
	  TABLOCK
	  );
PRINT('Load cust_info.csv successfully!')
PRINT('')

-- Load crm_prd_info
PRINT('Start load prd_info.csv')
TRUNCATE TABLE bronze.crm_prd_info
BULK INSERT bronze.crm_prd_info
FROM 'C:\sql\dwh_project\datasets\prd_info.csv'
WITH (FIRSTROW = 2,
	  FIELDTERMINATOR = ',',
	  TABLOCK
	  );
PRINT('Load prd_info.csv successfully!')

-- Load crm_sales_details
PRINT('Start load sales_details.csv')
TRUNCATE TABLE bronze.crm_sales_details
BULK INSERT bronze.crm_sales_details
FROM 'C:\sql\dwh_project\datasets\sales_details.csv'
WITH (FIRSTROW = 2,
	  FIELDTERMINATOR = ',',
	  TABLOCK
	  );
PRINT('Load sales_details.csv successfully!')

-- Load erp_cust_az12
PRINT('Start loadcust_az12.csv')
TRUNCATE TABLE bronze.erp_cust_az12
BULK INSERT bronze.erp_cust_az12
FROM 'C:\sql\dwh_project\datasets\cust_az12.csv'
WITH (FIRSTROW = 2,
	  FIELDTERMINATOR = ',',
	  TABLOCK
	  );
PRINT('Load cust_az12.csv successfully!')

-- Load erp_loc_a101
PRINT('Start load loc_a101.csv')
TRUNCATE TABLE bronze.erp_loc_a101
BULK INSERT bronze.erp_loc_a101
FROM 'C:\sql\dwh_project\datasets\loc_a101.csv'
WITH (FIRSTROW = 2,
	  FIELDTERMINATOR = ',',
	  TABLOCK
	  );
PRINT('Load loc_a101.csv successfully!')

-- Load erp_px_cat_g1v2
PRINT('Start load px_cat_g1v2.csv')
TRUNCATE TABLE bronze.erp_px_cat_g1v2
BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\sql\dwh_project\datasets\px_cat_g1v2.csv'
WITH (FIRSTROW = 2,
	  FIELDTERMINATOR = ',',
	  TABLOCK
	  );
PRINT('Load px_cat_g1v2.csv successfully!')

PRINT('Loading Complete!')

SET @end_time = GETDATE();
PRINT('Loading Time: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds.')