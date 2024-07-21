# MySQL Data Cleaning Project

## Table of Contents
- [Description](#description)
- [Dataset](#dataset)
- [SQL Queries](#sql-queries)
  - [Stage 1: Remove Duplicates](#stage-1-remove-duplicates)
  - [Stage 2: Standardize the Data](#stage-2-standardize-the-data)
  - [Stage 3: Handle Null and Blank Values](#stage-3-handle-null-and-blank-values)
  - [Stage 4: Remove Unwanted Columns](#stage-4-remove-unwanted-columns)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Description
This project involves cleaning a dataset (`layoff.csv`) using MySQL. The data cleaning process includes removing duplicates, standardizing data, handling null and blank values, and removing unwanted columns.

## Dataset
The dataset used in this project contains information about layoffs, including columns such as `COMPANY`, `LOCATION`, `INDUSTRY`, `TOTAL_LAID_OFF`, `DATE`, `STAGE`, `COUNTRY`, and `FUNDS_RAISED_MILLIONS`.

## SQL Queries
### Stage 0: Create a New Duplicate table
1. Create a new table to avoid modifying the raw dataset directly:
   ```sql
   CREATE TABLE LAYOFF_STAGE1 LIKE LAYOFFS;
   INSERT LAYOFF_STAGE1 SELECT * FROM LAYOFFS;

### Stage 1: Remove Duplicates

1. Identify and separate duplicate values:
   ```sql
    WITH DUPLICATE_TABLE AS (
    SELECT *, ROW_NUMBER() OVER(
    PARTITION BY COMPANY, LOCATION, INDUSTRY, TOTAL_LAID_OFF, `DATE`, STAGE, COUNTRY, FUNDS_RAISED_MILLIONS
    ) AS ROW_NUM FROM LAYOFF_STAGE1)
    SELECT * FROM DUPLICATE_TABLE WHERE ROW_NUM > 1;
   
2. Create a table for duplicates and remove them:
   ```sql
   CREATE TABLE REMOVED_DUPLICATE (
  `company` text, `location` text, `industry` text, `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text, `date` text, `stage` text, `country` text, 
  `funds_raised_millions` int DEFAULT NULL, `ROW_NUM` INT) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

  INSERT REMOVED_DUPLICATE SELECT *, ROW_NUMBER() OVER(
  PARTITION BY COMPANY, LOCATION, INDUSTRY, TOTAL_LAID_OFF, `DATE`, STAGE, COUNTRY, FUNDS_RAISED_MILLIONS) AS ROW_NUM 
  FROM LAYOFF_STAGE1;
  
  SET SQL_SAFE_UPDATES = 0;
  DELETE FROM REMOVED_DUPLICATE WHERE ROW_NUM > 1;
  SET SQL_SAFE_UPDATES = 1;

   
