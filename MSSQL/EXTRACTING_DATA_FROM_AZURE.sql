-- Set environment
USE WAREHOUSE COMPUTE_WH;   -- Select compute warehouse
USE ROLE ACCOUNTADMIN;       -- Set role with permissions
USE DATABASE PRICE_ANALYSIS; -- Use target database
USE SCHEMA FOODS_AND_VEG;   -- Use target schema

-- ==========================================
-- Create stage (commented out for security)
-- ==========================================

/*
The stage connects Snowflake to Azure Blob Storage.
SAS token is sensitive; 

CREATE OR REPLACE STAGE my_blob_stage
URL ='azure://<storagename>.blob.core.windows.net/stores'
CREDENTIALS=(AZURE_SAS_TOKEN='<Your Token>')
FILE_FORMAT=(TYPE=PARQUET);
*/

-- Create RAW tables to hold JSON data

CREATE OR REPLACE TABLE FRESHCO_RAW(
    raw VARIANT    -- Stores raw JSON from parquet files
);

CREATE OR REPLACE TABLE NOFRILLS_RAW(
    raw VARIANT    -- Stores raw JSON from parquet files
);

-- Load data from Azure into RAW tables

COPY INTO FRESHCO_RAW
FROM @my_blob_stage/freshco_raw.parquet
FILE_FORMAT = (TYPE = PARQUET); -- Load Freshco parquet file

COPY INTO NOFRILLS_RAW
FROM @my_blob_stage/no_frills.parquet
FILE_FORMAT = (TYPE = PARQUET); -- Load NoFrills parquet file

-- Inspect raw JSON

SELECT PARSE_JSON(raw:payload) AS payload_json
FROM NOFRILLS_RAW
LIMIT 1; -- Preview a single row

SELECT COUNT(raw) 
FROM NOFRILLS_RAW; -- Count total records


SELECT PARSE_JSON(raw:payload) 
FROM FRESHCO_RAW
LIMIT 1; -- Preview Freshco JSON

-- Transform NOFRILLS_RAW → NOFRILLS_CLEAN
CREATE OR REPLACE TABLE NOFRILLS_CLEAN AS 
SELECT
    payload:articleNumber::BIGINT AS articlenumber,
    payload:brand::STRING AS brand,
    payload:title::STRING AS name,
    payload:pricing:price::FLOAT AS price,
    payload:pricingUnits:type::STRING AS pricingtype,
    payload:pricingUnits:unit::STRING AS pricingunit
FROM (
    SELECT PARSE_JSON(raw:payload) AS payload
    FROM NOFRILLS_RAW
);

-- Transform FRESHCO_RAW → FRESHCO_CLEAN

CREATE OR REPLACE TABLE FRESHCO_CLEAN AS
SELECT
    payload:articleNumber::BIGINT AS articlenumber,
    payload:brand::STRING AS brand,
    payload:name::STRING AS name,
    payload:price::FLOAT AS price,
    payload:itemAmountValue::STRING AS amountvalue,
    payload:uom::STRING AS pricingtype,
    payload:itemAmountUnit::STRING AS pricingunit
FROM (
    SELECT PARSE_JSON(raw:payload) AS payload
    FROM FRESHCO_RAW
);
