USE ROLE USERADMIN;

CREATE ROLE IF NOT EXISTS movies_dlt_role;

CREATE ROLE IF NOT EXISTS movies_reader_role;

USE ROLE SECURITYADMIN;

-- grant to users
GRANT ROLE movies_dlt_role TO USER extract_loader;
GRANT ROLE movies_reader_role TO USER bettan92;
GRANT ROLE movies_dlt_role TO USER bettan92;

-- grant privileges to role
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE movies_dlt_role;
GRANT USAGE ON DATABASE movies TO ROLE movies_dlt_role;
GRANT USAGE ON SCHEMA movies.staging TO ROLE movies_dlt_role;

GRANT CREATE TABLE ON SCHEMA movies.staging TO ROLE movies_dlt_role;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA movies.staging TO ROLE movies_dlt_role;
GRANT INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA movies.staging TO ROLE movies_dlt_role;

-- check grants
SHOW GRANTS ON SCHEMA movies.staging;
SHOW FUTURE GRANTS IN SCHEMA movies.staging;
SHOW GRANTS TO ROLE movies_dlt_role;
SHOw GRANTS TO USER extract_loader;

-- see which role is being used
select current_role();


GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE movies_reader_role;
GRANT USAGE ON DATABASE movies TO ROLE movies_reader_role;
GRANT USAGE ON SCHEMA movies.staging TO ROLE movies_reader_role;
GRANT SELECT ON ALL TABLES IN SCHEMA movies.staging TO ROLE movies_reader_role;
GRANT SELECT ON FUTURE TABLES IN DATABASE movies TO ROLE movies_reader_role;
