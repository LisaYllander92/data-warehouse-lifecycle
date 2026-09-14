USE ROLE movies_reader_role;

SHOW DATABASES;

USE DATABASE movies;

DESCRIBE DATABASE movies;
DESCRIBE SCHEMA staging;

DESC TABLE staging.netflix;

SELECT * FROM staging.netflix;

--SHOW GRANTS ON TABLE staging.netflix;

SELECT count(*) FROM staging.netflix;