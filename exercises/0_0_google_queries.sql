-- Vilka warehouses finns?
SHOW WAREHOUSES;

--Välj warehouse
USE WAREHOUSE COMPUTE_WH;

-- Vilka databaser som finns
SHOW DATABASES;

-- Välj databas 
USE DATABASE GOOGLE_KEYWORDS_SEARCH_DATASET_DISCOVER_ALL_SEARCHES_ON_GOOGLE;

--Vilka schemas finns
SHOW SCHEMAS;

--Välj schema
USE SCHEMA DATAFEEDS;

-- Vilka tables finns
SHOW TABLES IN SCHEMA DATAFEEDS;

-- KOlla kolumner och datatyper
DESCRIBE TABLE google_keywords;


SELECT
    *
FROM
    GOOGLE_KEYWORDS
LIMIT 10;