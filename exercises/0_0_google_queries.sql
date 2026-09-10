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

SHOW VIEWS IN INFORMATION_SCHEMA;

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
    KEYWORD,
    COUNT(*) as total_count
FROM
    google_keywords
GROUP BY
    KEYWORD
ORDER BY
    total_count DESC
LIMIT
    10;

-- f) How many unique keywords are there?
SELECT
    COUNT(DISTINCT KEYWORD) as unique_keywords
FROM
    google_keywords;

-- g) Check what type of platforms are used and how many users per platform
SELECT
    platform,
    SUM(ROUND(calibrated_users, 2)) as total_users
FROM
    google_keywords
GROUP BY
    platform
ORDER BY
    total_users DESC;

--h) Let's dive into what swedish people are searching. 
-- Go into worldbanks country codes to find out the country code for Sweden. 
-- Find the 20 most popular keywords and the number of searches of that keyword.
SELECT
    keyword,
    COUNT(*) AS total_count
FROM
    google_keywords
WHERE
    country = '752'
GROUP BY
    keyword
ORDER BY
    total_count DESC
LIMIT
    20;

-- i) Lets see how popular spotify is around the world. List the top 10 number countries and the number of searches for spotify.
SELECT
country,
COUNT(*) AS search_count
FROM google_keywords
WHERE keyword = 'spotify'
GROUP BY country
ORDER BY search_count DESC
LIMIT 10;