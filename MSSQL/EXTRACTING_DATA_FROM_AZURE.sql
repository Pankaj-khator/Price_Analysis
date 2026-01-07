use warehouse COMPUTE_WH;
use database inventorymanagement;
use schema foods_and_veg;

create or replace stage my_blob_stage
URL ='azure://pankajdatalake.blob.core.windows.net/stores'
CREDENTIALS=(AZURE_SAS_TOKEN=('sp=racwdlmeop&st=2026-01-06T20:28:38Z&se=2027-01-01T04:43:38Z&spr=https&sv=2024-11-04&sr=c&sig=rSidea4THlktqhafdzM5uullx9DuMc8kugR3NTUjwus%3D'))
FILE_FORMAT=(TYPE=PARQUET);

CREATE OR REPLACE TABLE FRESHCO_RAW(
raw VARIANT
);

CREATE OR REPLACE TABLE NoFrills_RAW(
raw VARIANT
);

copy INTO FRESHCO_RAW
from @my_blob_stage/freshco_raw.parquet
FILE_FORMAT = (TYPE = PARQUET);

copy INTO NoFrills_RAW
from @my_blob_stage/no_frills.parquet
FILE_FORMAT = (TYPE = PARQUET);

SELECT
  PARSE_JSON(raw:payload) AS payload_json
FROM NoFrills_RAW
LIMIT 1;

select count(raw) from NoFrills_RAW;

create or replace table NoFrills_clean as 
select
payload:brand::string as Brand,
payload:title::string as title,
payload:packageSizing::string as packageSizing,
payload:pricing:price::float as price,
payload:pricingUnits:type::string as pricingtype,
payload:pricingUnits:unit::string as pricingunit from 
(select PARSE_JSON(raw:payload) AS payload
from NoFrills_RAW
);
