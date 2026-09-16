-- SYSADMIN is responsible for creating warehouse and databases
USE ROLE SYSADMIN;
CREATE WAREHOUSE dev_wh
WITH
WAREHOUSE_SIZE = 'XSMALL'
-- auto_suspend will close down the warehouse after ... seconds if there are no more querys
AUTO_SUSPEND = 60
-- so that the warehouse is still active even if you're not using it for a while
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE
COMMENT = 'Warehouse for development and analysis database.';

USE WAREHOUSE dev_wh;

SHOW WAREHOUSES;