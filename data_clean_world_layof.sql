SELECT * FROM LAYOFFS;
-- 1. REMOVE DUPLICATES
-- 2. STANDARDIZE THE DATA
-- 3. NULL VALUES AND BLANK VALUES
-- 4. REMOVE ANY COLUMNS UNWANTED COLUMN

-- STAGE 1 REMOVE DUPLICATES
-- CREATE NEW TABLE STAGE1 LIKE LAYOFFS TO AVOID MISTAKE IN RAW DATASET
CREATE TABLE LAYOFF_STAGE1 LIKE LAYOFFS;
-- INSERT VALUES FROM LAYOFF DATASET
INSERT LAYOFF_STAGE1
SELECT * FROM LAYOFFS;

SELECT * FROM LAYOFF_STAGE1;

-- SEPARATE DUPLICATE VALUE FORM STAGE1
WITH DUPLICATE_TABLE AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY,LOCATION,INDUSTRY,TOTAL_LAID_OFF,`DATE`,STAGE,COUNTRY,FUNDS_RAISED_MILLIONS
) AS ROW_NUM
FROM LAYOFF_STAGE1
)
SELECT * FROM DUPLICATE_TABLE
WHERE ROW_NUM>1;

-- CHECKING IS DATA IS DUPLICATE PAST VALUE IN WHARE CLASS
SELECT * FROM LAYOFF_STAGE1
WHERE COMPANY='Casper';

-- DELETE DUPLICATE BY CREATING NEW TABLE
CREATE TABLE `REMOVED_DUPLICATE` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `ROW_NUM` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT REMOVED_DUPLICATE
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY,LOCATION,INDUSTRY,TOTAL_LAID_OFF,`DATE`,STAGE,COUNTRY,FUNDS_RAISED_MILLIONS
) AS ROW_NUM
FROM LAYOFF_STAGE1;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM REMOVED_DUPLICATE
WHERE ROW_NUM>1;

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM REMOVED_DUPLICATE;

-- STAGE 2 STANDARDIZE THE DATA
-- ITREATE COLUMN ONE BY ONE
-- COLUMN 1 "COMPANY"
SELECT COMPANY FROM removed_duplicate;

SET SQL_SAFE_UPDATES = 0;

UPDATE removed_duplicate
SET COMPANY=TRIM(COMPANY);

-- COLUMN 2 LOCATION
SELECT distinct(LOCATION) FROM removed_duplicate
ORDER BY 1;
UPDATE removed_duplicate
SET LOCATION=TRIM(LOCATION);

-- COLUMN 3 "INDUSTRY" 

SELECT distinct(INDUSTRY) FROM removed_duplicate
ORDER BY 1;
UPDATE REMOVED_DUPLICATE
SET INDUSTRY=TRIM(INDUSTRY);
UPDATE REMOVED_DUPLICATE
SET INDUSTRY='Crypto'
WHERE INDUSTRY LIKE 'CRYPTO%';

-- COLUMN "COUNTRY"
SELECT DISTINCT(COUNTRY) FROM removed_duplicate
ORDER BY 1;
UPDATE REMOVED_DUPLICATE
SET INDUSTRY=TRIM(INDUSTRY);
UPDATE REMOVED_DUPLICATE
SET COUNTRY='United States'
WHERE COUNTRY LIKE 'United States%';

-- COLUNM DATE HERE DATE IN STR DATA TYPE CONVERT IT TO DATE DATA TYPE BY USING STRTODATE() -> UPDATE -> ALTER MODIFY

SELECT `DATE` FROM removed_duplicate;

UPDATE removed_duplicate
SET `DATE` = str_to_date(`DATE`,'%m/%d/%Y');
-- STILL IT IS IN STR FROMATE
ALTER TABLE REMOVED_DUPLICATE
MODIFY COLUMN `DATE` DATE;

SELECT * FROM REMOVED_DUPLICATE;
-- STAGE3 REMOVE NULL VALUES AND BLANK VALUES. TRY TO POPULATE DATA ELSE REMOVE NULL DATA
SELECT COMPANY FROM removed_duplicate
WHERE company='NULL' OR COMPANY="";
SELECT INDUSTRY FROM removed_duplicate
WHERE INDUSTRY IS NULL OR INDUSTRY="";

-- NOW CONVERT ALL BLANK VALUES TO NULL VALUES
UPDATE REMOVED_DUPLICATE
SET  INDUSTRY = NULL
WHERE INDUSTRY ='';

-- NOW POPULATE DATA
SELECT T1.INDUSTRY, T2.INDUSTRY FROM removed_duplicate T1
JOIN removed_duplicate T2 
ON T1.company=T2.company
WHERE T1.industry IS NULL AND T2.industry IS NOT NULL;

-- UPDATE POPULATE DATA
UPDATE REMOVED_DUPLICATE T1
JOIN removed_duplicate T2 
ON T1.company=T2.company
SET T1.industry=T2.industry
WHERE T1.industry IS NULL AND T2.industry IS NOT NULL;

-- CHECK TABLE WHERE IS UPDATED OR NOT
SELECT INDUSTRY FROM removed_duplicate
WHERE INDUSTRY IS NULL OR INDUSTRY="";

-- NOW CHECK COLUMN TOTAL_LAID_OFF , PERCENTAGE_LAY_OFF HERE PROBLE IS WE CAN'T POPULATE DATA WHEN THERE IS NO DATA IN BOTH COLUMN
-- CHECK ROWS WHICH DIDNT HAVE DATA IN BOTH TOTAL_LAID_OFF , PERCENTAGE_LAY_OFF

SELECT * FROM removed_duplicate
WHERE (total_laid_off IS NULL OR total_laid_off ="") AND (percentage_laid_off IS NULL OR percentage_laid_off = "");

-- NOW REMOVE ROWS WHICH WE SELECTED
DELETE FROM removed_duplicate
WHERE (total_laid_off IS NULL OR total_laid_off ="") AND (percentage_laid_off IS NULL OR percentage_laid_off = "");

-- NOW CHECK TABLE CONTAIN NULL VALUES OR NOT
SELECT * FROM removed_duplicate;

-- STAGE4 REMOVE ANY COLUMNS UNWANTED COLUMN
-- HERE UNWANTED COLUMN IS WE CREATE ROW_NUM FOR CHECKING DUPLICATE NOW WE REMOVE IT 

ALTER TABLE removed_duplicate
DROP column ROW_NUM;

-- NOW CLEAN DATA AS MUCH POSSIBLE
SELECT * FROM removed_duplicate;

