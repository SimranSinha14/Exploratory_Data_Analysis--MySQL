-- Exploratory Data Analysis


-- MAXIMUM and Minimum total layoff in a company 
SELECT MAX(total_laid_off), MIN(total_laid_off)
FROM layoffs_staging2;


-- Earliest and latest months of layoffs
SELECT MAX(`date`) as earliest_month , MIN(`date`) as latest_month
FROM layoffs_staging2;

-- total layoffs by each company

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

-- Top 5 company that have highest layoffs
SELECT company , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY  2 DESC
LIMIT 5;

-- TOP 5 industry that have maximum layoffs
SELECT industry , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC
LIMIT 5;

-- the company and year with the maximum total number of laid-off employees
SELECT company, year(`date`) , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1,2
HAVING SUM(total_laid_off) = 
(
SELECT MAX(total_laid_off)
FROM layoffs_staging2)
ORDER BY 2;

-- top 5 countries with maximum layoffs
SELECT country , SUM(total_laid_off) as total_off
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
LIMIT 5;

-- total layoff as per year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 1;
-- total sum of layoff by per month
SELECT SUBSTR(`date`,1,7) as month_year,SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTR(`date`,1,7) is not null
GROUP BY month_year
ORDER BY month_year;

-- Time when maximum layoff happened
WITH Layoff_per_month as (
SELECT SUBSTR(`date`,1,7) as month_year,SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTR(`date`,1,7) is not null
GROUP BY SUBSTR(`date`,1,7)
ORDER BY month_year
)

SELECT month_year, total_off
FROM Layoff_per_month
WHERE total_off = ( 
      SELECT MAX(total_off)
      FROM Layoff_per_month)
;

-- rolling total
WITH rolling_total as ( 
 SELECT SUBSTR(`date`,1,7) as month_year,SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTR(`date`,1,7) is not null
GROUP BY month_year
ORDER BY month_year ASC
)

SELECT month_year,total_off,
SUM(total_off) OVER (ORDER BY month_year) as rolling_off
FROM rolling_total;

-- Ranking the company as per the total layoffs in respective year
WITH company_year (company, years, total_laid_off) as (
SELECT company , YEAR(`date`)  , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1,2
),

company_year_ranking as (
SELECT *, 
DENSE_RANK() OVER ( PARTITION BY years ORDER BY total_laid_off DESC) as ranking
FROM company_year
WHERE years is not null 
)
SELECT *
FROM company_year_ranking
WHERE ranking <=5
;






 







