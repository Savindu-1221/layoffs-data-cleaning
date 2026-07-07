# Layoffs Data Cleaning — MySQL

## Project Overview
Cleaned a real world layoffs dataset using MySQL.
The raw data contained duplicates, inconsistent values,
NULL values and unnecessary columns.

## What I did

### 1. Removed duplicates
Identified and removed duplicate rows to ensure
each record appears only once.

### 2. Standardized the data
- Fixed inconsistent text values
- Standardized location names across different countries
- Fixed encoding issues in foreign language city names
- Trimmed extra spaces from all text columns

### 3. Handled NULL and blank values
- Identified columns with missing values
- Filled NULLs where possible using other rows
from the same company
- Flagged remaining NULLs for review

### 4. Removed unnecessary rows and columns
Dropped columns and rows that were not useful
for analysis.

## Tools used
- MySQL 8.0

## Dataset
My own real world layoffs dataset.

## Key learning
This project taught me how to handle real world
dirty data problems including encoding issues,
duplicate detection and NULL value strategies.
