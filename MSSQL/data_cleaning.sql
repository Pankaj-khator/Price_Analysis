-- Set environment
USE WAREHOUSE COMPUTE_WH;  -- Select compute warehouse
USE ROLE ACCOUNTADMIN;      -- Use admin role for full permissions
USE DATABASE price_analysis; -- Select database
USE SCHEMA FOODS_AND_VEG;  -- Select schema



-- Inspect tables in the schema
SHOW TABLES IN PRICE_ANALYSIS.FOODS_AND_VEG; -- List all tables in schema

-- Preview data from FRESHCO_CLEAN
SELECT * 
FROM FOODS_AND_VEG.FRESHCO_CLEAN
LIMIT 1; -- Preview a single record to check structure

-- Search for products containing 'bread'
SELECT * 
FROM FOODS_AND_VEG.NoFrills_clean
WHERE name LIKE '%bread%'; -- Filter NoFrills products with 'bread' in the name

SELECT * 
FROM FOODS_AND_VEG.FRESHCO_CLEAN
WHERE name LIKE '%bread%'; -- Filter Freshco products with 'bread' in the name

-- Ensure correct schema context before joins
USE SCHEMA foods_and_veg; -- Ensure correct schema context

-- Compare prices and details by joining tables
SELECT 
    f.articlenumber,   -- Product ID from Freshco
    f.name,            -- Product name from Freshco
    n.name,            -- Product name from NoFrills
    f.price,           -- Price from Freshco
    n.price,           -- Price from NoFrills
    f.pricingtype,     -- Pricing type from Freshco 
    n.pricingtype      -- Pricing type from NoFrills
FROM FRESHCO_CLEAN f
JOIN NoFrills_clean n 
    ON f.articlenumber = n.articlenumber; -- Join on unique product ID to compare prices
