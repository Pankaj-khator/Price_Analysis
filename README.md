# Grocery Price Analysis Pipeline (Fresh Fruits & Vegetables)
## 📌 Project Overview

This project builds an end-to-end data pipeline to extract, store, and analyze grocery product pricing data from multiple Canadian retailers, with an initial focus on the Fresh Fruits and Vegetables category.

The goal is to design a scalable, cloud-based analytics pipeline that supports raw data ingestion, structured transformation, and cross-retailer price comparison using modern data engineering tools.

## 🎯 Project Objectives

Extract product-level data from retailer APIs (Freshco & No Frills)

Preserve raw source data for traceability and reprocessing

Store data efficiently using Parquet format in cloud storage

Load and analyze data in Snowflake

Enable retailer-to-retailer price comparison at the product level

Follow analytics engineering best practices (raw → clean → analytics)

## 📂 Project Scope

This project currently focuses only on the Fresh Fruits and Vegetables category.

This limitation is intentional, allowing the pipeline to be:

Built end-to-end

Validated with real production-like data

Debugged without unnecessary complexity

The architecture is scalable by design and can be extended to include all product categories in the future with minimal changes to the extraction and transformation logic.

## 🧱 Architecture Overview
<img width="330" height="266" alt="Screenshot 2026-01-08 at 1 59 29 PM" src="https://github.com/user-attachments/assets/86674312-8b3a-438f-84d5-96268c8dfe3b" />


## 🔧 Technology Stack
Layer	Technology
Extraction	Python, Requests
Data Format	Parquet (PyArrow)
Cloud Storage	Azure Blob Storage
Data Warehouse	Snowflake (Azure)
Transformation	SQL (Snowflake)
Analytics	SQL, Power BI
Version Control	GitHub

## 📥 Data Extraction

Data is extracted via authenticated retailer APIs

Pagination is handled programmatically

Each product record is stored as:

payload → full raw JSON (stringified)

extracted_at → UTC timestamp

source → data origin (Freshco / No Frills)

This ensures:

No data loss

Full replay capability

Schema evolution safety

## 📦 Storage Strategy (Why Parquet?)

Raw data is stored in Parquet format because:

Columnar storage = faster analytics

Smaller file size than JSON or CSV

Native compatibility with Snowflake

Ideal for cloud-based data lakes

Parquet acts as the single source of truth before transformations.

## ❄️ Snowflake Data Model
Raw Layer

Stores raw Parquet data as a single VARIANT column

No transformations applied

Immutable historical record

Clean Layer

Extracts structured fields from payload

Normalizes product identifiers

Standardizes pricing and units

Analytics Layer

Joins Freshco and No Frills data

Enables price comparison by:

Article number

Product name

Brand

Price & pricing type

## 📊 Sample Analysis

Example use cases:

Price comparison of the same product across retailers

Identifying pricing discrepancies

Monitoring price volatility by product

Future expansion to basket-level analysis

## 🔐 Security & Credentials

API keys and SAS tokens are stored using environment variables

No secrets are committed to GitHub

Azure Blob access uses SAS-based authentication

## 🚀 Future Enhancements

Expand ingestion to all product categories

Add scheduling (Airflow / Azure Data Factory)

Implement incremental loads

Introduce data quality checks

Build Power BI dashboards

Enable historical price trend analysis

## 🧠 Key Design Decisions

Raw-first ingestion to avoid irreversible data loss

Parquet over CSV/JSON for performance and scalability

Snowflake VARIANT for flexible schema handling

Category scoping for faster validation and learning

## 📎 Disclaimer

This project is built for educational and analytical purposes.
All data is sourced from publicly accessible APIs and is used strictly for learning and analysis.

>>>>>>> remote