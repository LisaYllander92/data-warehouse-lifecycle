USE ROLE sysadmin;

CREATE DATABASE IF NOT EXISTS movies;

CREATE SCHEMA IF NOT EXISTS movies.staging;

-- Check if it exists
DESCRIBE DATABASE movies;