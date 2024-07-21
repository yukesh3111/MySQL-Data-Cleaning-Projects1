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

### Stage 1: Remove Duplicates
1. Create a new table to avoid modifying the raw dataset directly:
   ```sql
   CREATE TABLE LAYOFF_STAGE1 LIKE LAYOFFS;
   INSERT LAYOFF_STAGE1 SELECT * FROM LAYOFFS;
