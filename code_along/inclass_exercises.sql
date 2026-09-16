/*Question 1
Based on the lecture/code along sql worksheets:
using the ice_cream_writer role, create a new table under the public schema. This is a table called suppliers with the columns: supplier_id and supplier_name
as an object manager, can you use the role SYSADMIN to drop this table. Because we find out that this is a wrong table to be created
by going through this step, can you conclude that our lecture/code along sql worksheets follows strictly the snowflake best practice of access control */

USE ROLE ice_cream_writer;
USE WAREHOUSE dev_wh;
USE SCHEMA ice_cream_db.public;

CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id INT AUTOINCREMENT PRIMARY KEY ,
    supplier_name STRING
);

SHOW TABLES IN ice_cream_db.public;

USE ROLE SYSADMIN;

DROP TABLE suppliers;

