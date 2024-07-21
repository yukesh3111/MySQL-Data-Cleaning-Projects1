# MySQL Data Cleaning Project
![Project Banner]([path/to/your/image.jpg](https://th.bing.com/th/id/OIP.wsus-_9qxZ6aYYVI8lj5LwHaGB?rs=1&pid=ImgDetMain))
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
### Stage 2: Standardize the Data

1. Standardize `COMPANY` and `LOCATION`:
   ```sql
     UPDATE removed_duplicate SET COMPANY = TRIM(COMPANY);
     UPDATE removed_duplicate SET LOCATION = TRIM(LOCATION);

2. Standardize INDUSTRY and COUNTRY:
   ```sql
   UPDATE REMOVED_DUPLICATE SET INDUSTRY = TRIM(INDUSTRY);
   UPDATE REMOVED_DUPLICATE SET INDUSTRY = 'Crypto' WHERE INDUSTRY LIKE 'CRYPTO%';
   UPDATE REMOVED_DUPLICATE SET COUNTRY = 'United States' WHERE COUNTRY LIKE 'United States%';

3. Convert DATE to DATE data type:
   ```sql
   UPDATE removed_duplicate SET `DATE` = str_to_date(`DATE`,'%m/%d/%Y');
   ALTER TABLE REMOVED_DUPLICATE MODIFY COLUMN `DATE` DATE;

### Stage 3: Handle Null and Blank Values

1. Convert blank values to null:
   ```sql
   UPDATE REMOVED_DUPLICATE SET INDUSTRY = NULL WHERE INDUSTRY = '';

2. Populate missing INDUSTRY values:
   ```sql
   UPDATE REMOVED_DUPLICATE T1 JOIN removed_duplicate T2
   ON T1.company = T2.company SET T1.industry = T2.industry
   WHERE T1.industry IS NULL AND T2.industry IS NOT NULL;

3. Remove rows with missing TOTAL_LAID_OFF and PERCENTAGE_LAID_OFF:
   ```sql
   DELETE FROM removed_duplicate WHERE (total_laid_off IS NULL OR total_laid_off = '')
   AND (percentage_laid_off IS NULL OR percentage_laid_off = '');

### Stage 4: Remove Unwanted Columns

1. Remove the ROW_NUM column:
   ```sql
   ALTER TABLE removed_duplicate DROP column ROW_NUM;

## Usage

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/mysql-data-cleaning.git

2. Navigate to the project directory
   ```sh
   cd mysql-data-cleaning

3. Execute the SQL queries in your MySQL environment.
   
