/*
========================================================================================================================
Create Database and Schemas
========================================================================================================================
Script Purpose: 
This Script will create Database nameed "DataWarehouse" and create three new schemas: "bronze", "silver" and "gold".
*/

USE master;
GO

-- Create "Datawarehouse" database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create schema
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
