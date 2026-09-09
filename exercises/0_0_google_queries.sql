/*Go into marketplace under data products in snowsight. 
Search and get the following dataset Google Keywords search dataset - discover all searches on Google.
Now create a worksheet on your local repository and start querying this data through vscode.
a) Use this database and find out the underlying schemas, tables and views to get an overview of its logical structure.?*/
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

-- Vilka tables finns - NAME GOOGLE_KEYWORDS (table)
SHOW TABLES IN SCHEMA DATAFEEDS;

-- b) Find out the columns and its data types in the table GOOGLE_KEYWORDS.
--Kolla kolumner och datatyper i google_keywords
DESCRIBE TABLE google_keywords;

SELECT
    *
FROM
    GOOGLE_KEYWORDS
LIMIT
    10;

/*We will now do some exploratory data analysis (EDA) of this dataset.
c) Find out number of rows in the dataset.*/
SELECT
    COUNT(*) AS num_rows
FROM
    google_keywords;

-- d) When is the first search and when is the latest search in the dataset?
SELECT
    MIN(DATE) AS first_date,
    MAX(DATE) AS last_date
FROM
    google_keywords;

-- e) Which are the 10 most popular keywords?
SELECT
    KEYWORD
FROM
    google_keywords
GROUP BY
    KEYWORD
ORDER BY
    COUNT(*)
LIMIT
    10;