USE ROLE job_ads_dlt_role;

USE DATABASE job_ads;

SHOW SCHEMAS;

SHOW TABLES IN SCHEMA staging;

DESC TABLE staging.data_field_job_ads;

SELECT
    headline,
    employer__workplace,
    description__text
FROM
    staging.data_field_job_ads;

SELECT
    *
FROM
    staging.data_field_job_ads
WHERE
    employer__workplace = 'ATG';