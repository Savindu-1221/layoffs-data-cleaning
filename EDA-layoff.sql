-- Exploratory Data Analysis
-- Layoffs Dataset (2020-2023)

-- 1. Total layoffs by company

SELECT company, SUM(total_laid_off) AS total
FROM layoffs_stage2
WHERE total_laid_off IS NOT NULL
GROUP BY company
ORDER BY total DESC;

-- 2. Total layoffs by industry

SELECT industry, SUM(total_laid_off) AS total
FROM layoffs_stage2
WHERE total_laid_off IS NOT NULL
GROUP BY industry
ORDER BY total DESC;

-- 3. Total layoffs by country

SELECT country, SUM(total_laid_off) AS total
FROM layoffs_stage2
WHERE total_laid_off IS NOT NULL
GROUP BY country
ORDER BY total DESC;

-- 4. Total layoffs by year

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stage2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`);

-- 5. Total layoffs by month

SELECT SUBSTRING(`date`,1,7), SUM(total_laid_off)
FROM layoffs_stage2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY SUBSTRING(`date`,1,7); 

-- 6. Rolling total of layoffs per month

WITH rolling_total (_month_, total) AS
(
	SELECT SUBSTRING(`date`,1,7), SUM(total_laid_off)
	FROM layoffs_stage2
	WHERE SUBSTRING(`date`,1,7) IS NOT NULL
	GROUP BY SUBSTRING(`date`,1,7)
	ORDER BY SUBSTRING(`date`,1,7)
)
SELECT *, SUM(total) OVER (ORDER BY _month_)
FROM rolling_total;

-- 7. Companies that laid off 100% of staff

SELECT company, country, funds_raised_millions
FROM layoffs_stage2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- 8. Top 5 companies with most layoffs per year

WITH company_year (company, _year, total) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stage2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY company, YEAR(`date`)

), company_ranking AS (
SELECT *,
RANK() OVER (PARTITION BY _year ORDER BY total DESC) AS total_rank
FROM company_year
)
SELECT *
FROM company_ranking
WHERE total_rank <= 5;
