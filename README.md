# Data Warehouse and Analytics Project

This project demonstrates a complete Data Analytics lifecycle, transforming raw retail transactional data into a **Data Warehouse** using **Medallion Architecture**. The final result is a professional **Power BI Dashboard** that empowers business stakeholders to make data-driven decisions regarding sales, profitability.

---
## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:

![Data Architecture](docs/data_architecture.png)

1. **Bronze Layer**: Stores raw data from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer is about data cleansing, data transformation and standarization to prepare data for analysis.
3. **Gold Layer**: This layer is about prepare  business-ready data modeled into a star schema required for reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.
---
