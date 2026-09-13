## Repo för kursen Dara Warehouse (Snowflake)

-- KONTOINFORMATION
-- Visa nuvarande region
SELECT CURRENT_REGION();

-- Visa nuvarande konto och organisation
SELECT CURRENT_ACCOUNT(), CURRENT_ORGANIZATION_NAME();

-- Visa nuvarande roll, warehouse, databas och schema
SELECT CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

-- Visa Snowflake-version (klient/servervarning)
SELECT CURRENT_VERSION();

-- Visa aktuell användare
SELECT CURRENT_USER();


-- EDITION OCH KONTOÖVERSIKT (kräver ACCOUNTADMIN eller motsvarande rättigheter)
-- Lista alla konton i organisationen med edition, region m.m.
SHOW ORGANIZATION ACCOUNTS;

-- Alternativ: detaljerad kontoinfo via ACCOUNT_USAGE
SELECT ACCOUNT_NAME, EDITION, REGION, CREATED_ON
FROM SNOWFLAKE.ORGANIZATION_USAGE.ACCOUNTS;


-- CREDIT-FÖRBRUKNING
-- Totalt antal credits förbrukade (alla tider, i ACCOUNT_USAGE-schemat)
SELECT SUM(CREDITS_USED) AS TOTAL_CREDITS
FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_HISTORY;

-- Credits förbrukade per dag, senaste 30 dagarna
SELECT TO_DATE(START_TIME) AS USAGE_DATE, SUM(CREDITS_USED) AS DAILY_CREDITS
FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_HISTORY
WHERE START_TIME >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY USAGE_DATE
ORDER BY USAGE_DATE;

-- Credits förbrukade per warehouse
SELECT WAREHOUSE_NAME, SUM(CREDITS_USED) AS TOTAL_CREDITS
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
GROUP BY WAREHOUSE_NAME
ORDER BY TOTAL_CREDITS DESC;


-- ÖVRIGT ANVÄNDBART
-- Lista alla warehouses i kontot
SHOW WAREHOUSES;

-- Lista alla databaser
SHOW DATABASES;

-- Visa parametrar för kontot (t.ex. inställningar kring auto-suspend etc.)
SHOW PARAMETERS IN ACCOUNT;