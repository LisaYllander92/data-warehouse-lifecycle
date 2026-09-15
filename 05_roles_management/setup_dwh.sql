-- SYSADMIN is responsible for creating warehouse and databases
USE ROLE SYSADMIN;
CREATE WAREHOUSE dev_wh
WITH
WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE
COMMENT = 'Warehouse for development and analysis database.';

USE WAREHOUSE dev_wh;

SHOW WAREHOUSES;