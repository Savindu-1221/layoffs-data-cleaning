
SELECT *
FROM layoffs;

-- 1. remove duplicates

CREATE TABLE layoffs_stage1 LIKE layoffs;  

SELECT * 
FROM layoffs_stage1;            

INSERT INTO layoffs_stage1		
SELECT * FROM layoffs;

WITH duplicate_cte AS     
(																											
SELECT *,
ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num   
FROM layoffs_stage1
)
DELETE 
FROM duplicate_cte   
WHERE row_num > 1;  

CREATE TABLE `layoffs_stage2` (		
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_stage2;

INSERT INTO layoffs_stage2				
SELECT *,																															
ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stage1;

DELETE  					
FROM layoffs_stage2   
WHERE row_num > 1;

-- 2. standardize the data

SELECT DISTINCT company
FROM layoffs_stage2
ORDER BY 1;

UPDATE layoffs_stage2			
SET
company = TRIM(company),
location = TRIM(location),
industry = TRIM(industry),
stage = TRIM(stage),
country = TRIM(country) ;

SELECT DISTINCT company				
FROM layoffs_stage2
WHERE company LIKE '%.'
ORDER BY 1;

UPDATE layoffs_stage2
SET company = 'E Inc'
WHERE company = 'E Inc.';

SELECT DISTINCT location
FROM layoffs_stage2
ORDER BY 1;

UPDATE layoffs_stage2				
SET location = 'Düsseldorf'
WHERE location = 'DÃ¼sseldorf';

UPDATE layoffs_stage2				
SET location = 'Florianópolis'
WHERE location = 'FlorianÃ³polis';


UPDATE layoffs_stage2				
SET location = 'Malmö'
WHERE location = 'MalmÃ¶';

SELECT DISTINCT location			
FROM layoffs_stage2
WHERE location LIKE 'Malm%'
ORDER BY 1;

UPDATE layoffs_stage2				
SET location = 'Malmö'
WHERE location = 'Malmo';

SELECT DISTINCT location, TRIM(TRAILING '.' FROM location)  
FROM layoffs_stage2
ORDER BY 1;

UPDATE layoffs_stage2
SET location = TRIM(TRAILING '.' FROM location)  
WHERE location LIKE 'Washington D.C%';

SELECT *
FROM layoffs_stage2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_stage2				
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

SELECT DISTINCT stage
FROM layoffs_stage2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_stage2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)  
FROM layoffs_stage2
ORDER BY 1;

UPDATE layoffs_stage2			
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT * 
FROM layoffs_stage2;

SELECT `date`
FROM layoffs_stage2;

UPDATE layoffs_stage2
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y');

ALTER TABLE layoffs_stage2
MODIFY COLUMN `date` DATE ;   

-- 3. null values or blank values

SELECT * 
FROM layoffs_stage2;

SELECT DISTINCT company 		
FROM layoffs_stage2;

SELECT DISTINCT location 		
FROM layoffs_stage2;

SELECT DISTINCT industry 		
FROM layoffs_stage2;

SELECT *
FROM layoffs_stage2
WHERE industry = '' 
OR industry IS NULL
ORDER BY 1;

UPDATE layoffs_stage2
SET industry = null
WHERE industry = '';

SELECT *
FROM layoffs_stage2
WHERE company = "Carvana"; 

SELECT t1.industry, t2.industry
FROM layoffs_stage2 AS t1
JOIN layoffs_stage2 AS t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL ;

UPDATE layoffs_stage2 AS t1
JOIN layoffs_stage2 AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL ;

SELECT *
FROM layoffs_stage2
ORDER BY company; 


-- 4. remove rows or columns

SELECT *
FROM layoffs_stage2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL ;

DELETE
FROM layoffs_stage2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL ;

ALTER TABLE layoffs_stage2
DROP COLUMN row_num;















