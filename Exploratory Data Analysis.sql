-- Exploratory Data Analysis

SELECT *
FROM `layoffs_staging2` AS `ls2`;

SELECT MAX(ls2.`total_laid_off`), MAX(ls2.`percentage_laid_off`)
FROM `layoffs_staging2` AS `ls2`;

SELECT *
FROM `layoffs_staging2` AS `ls2`
WHERE ls2.`percentage_laid_off` = 1
ORDER BY ls2.`funds_raised_millions` DESC;

SELECT ls2.`company`, SUM(ls2.`total_laid_off`)
FROM `layoffs_staging2` AS `ls2`
GROUP BY ls2.`company`
ORDER BY 2 DESC;

SELECT MIN(ls2.`date`), MAX(ls2.`date`)
FROM `layoffs_staging2` AS `ls2`;

SELECT ls2.`country`, SUM(ls2.`total_laid_off`)
FROM `layoffs_staging2` AS `ls2`
GROUP BY ls2.`country`
ORDER BY 2 DESC;

SELECT *
FROM `layoffs_staging2` AS `ls2`;

SELECT YEAR(ls2.`date`), SUM(ls2.`total_laid_off`)
FROM `layoffs_staging2` AS `ls2`
GROUP BY YEAR(ls2.`date`)
ORDER BY 1 DESC;

SELECT ls2.`stage`, SUM(ls2.`total_laid_off`)
FROM `layoffs_staging2` AS `ls2`
GROUP BY ls2.`stage`
ORDER BY 2 DESC;

SELECT ls2.`company`, AVG(ls2.`percentage_laid_off`)
FROM `layoffs_staging2` AS `ls2`
GROUP BY ls2.`company`
ORDER BY 2 DESC;

SELECT SUBSTRING(ls2.`date`, 1, 7) AS `MONTH`, SUM(ls2.`total_laid_off`)
FROM `layoffs_staging2` AS `ls2`
WHERE SUBSTRING(ls2.`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH `Rolling_total` AS
(SELECT SUBSTRING(ls2.`date`, 1, 7) AS `MONTH`, 
SUM(ls2.`total_laid_off`) AS `total_off`
FROM `layoffs_staging2` AS `ls2`
WHERE SUBSTRING(ls2.`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, `total_off`,
SUM(`TOTAL_OFF`) OVER(ORDER BY `MONTH`) AS `rolling_total`
FROM `Rolling_total`;

SELECT ls2.`company`, SUM(ls2.`total_laid_off`)
FROM `layoffs_staging2` AS `ls2`
GROUP BY ls2.`company`
ORDER BY 2 DESC;

SELECT ls2.`company`, YEAR(ls2.`date`), SUM(ls2.`total_laid_off`)
FROM `layoffs_staging2` AS `ls2`
GROUP BY ls2.`company`, YEAR(ls2.`date`)
ORDER BY ls2.`company` ASC;

SELECT ls2.`company`, YEAR(ls2.`date`), SUM(ls2.`total_laid_off`)
FROM `layoffs_staging2` AS `ls2`
GROUP BY ls2.`company`, YEAR(ls2.`date`)
ORDER BY 3 DESC;

WITH `Company_year` (company, months, total_laid_off) AS
(
SELECT ls2.`company`, CONCAT(YEAR(ls2.`date`), '-', MONTH(ls2.`date`)) AS `months`, SUM(ls2.`total_laid_off`)
FROM `layoffs_staging2` AS `ls2`
GROUP BY ls2.`company`, `months`
), `Company_year_rank` AS
(
SELECT *, 
DENSE_RANK() OVER (PARTITION BY months ORDER BY total_laid_off DESC) AS `Ranking`
FROM `Company_year`
WHERE months IS NOT NULL
) 
SELECT *
FROM `Company_year_rank`
WHERE 1 
and `company` = 'Uber';



