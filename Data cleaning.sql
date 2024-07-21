-- DATA CLEANING 


SELECT *
FROM `layoffs`;


-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values  
-- 4. Remove Any Columns 
 

CREATE TABLE `layoffs_staging`
LIKE `layoffs`;


SELECT *
FROM `layoffs_staging`;


INSERT `layoffs_staging`
SELECT *
FROM `layoffs`;

-- 1. Remove Duplicates 

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, `date`,
`stage`, `country`, `funds_raised_millions`) AS `row_number`
FROM `layoffs_staging`;

WITH `duplicate_cte` AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, `date`,
`stage`, `country`, `funds_raised_millions`) AS `row_number`
FROM `layoffs_staging`
)
SELECT *
FROM `duplicate_cte`
WHERE `row_number` > 1
;


SELECT *
FROM `layoffs_staging`
WHERE `company` = 'Casper' 
;


WITH `duplicate_cte` AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, `date`,
`stage`, `country`, `funds_raised_millions`) AS `row_number`
FROM `layoffs_staging`
)
DELETE 
FROM `duplicate_cte`
WHERE `row_number` > 1
;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




DELETE
FROM `layoffs_staging2`
WHERE `row_num` > 1
;


INSERT INTO `layoffs_staging2`
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, `date`,
`stage`, `country`, `funds_raised_millions`) AS `row_number`
FROM `layoffs_staging`
;


SELECT *
FROM `layoffs_staging2`
;


-- 2. Standardizing data

SELECT `company`, TRIM(`company`)
FROM `layoffs_staging2`
;

UPDATE `layoffs_staging2`
SET `company` = TRIM(`company`);

SELECT *
FROM `layoffs_staging2`
WHERE `industry` LIKE 'Crypto%'
;


UPDATE `layoffs_staging2` as `ls2`
SET ls2.`industry` = 'Crypto'
WHERE ls2.`industry` LIKE 'Crypto%'
;

SELECT DISTINCT ls2.`industry`
FROM `layoffs_staging2` as ls2
;

SELECT *
FROM `layoffs_staging2`;



SELECT DISTINCT ls2.`country`, TRIM(TRAILING '.' FROM ls2.`country`)
FROM `layoffs_staging2` as ls2
ORDER BY 1
;

UPDATE `layoffs_staging2` AS `ls2`
SET `country` = TRIM(TRAILING '.' FROM ls2.`country`)
WHERE country LIKE 'United States%'
;

SELECT DISTINCT ls2.`country`
FROM `layoffs_staging2` as ls2
WHERE ls2.`country` LIKE 'United States%'
;

SELECT DISTINCT ls2.`country`
FROM `layoffs_staging2` as ls2
ORDER BY 1
;


-- Date formating 

SELECT ls2.`date`
FROM `layoffs_staging2` as ls2
;


UPDATE `layoffs_staging2` AS `ls2`
SET ls2.`date` = STR_TO_DATE(ls2.`date`, '%m/%d/%Y')
;

ALTER TABLE `layoffs_staging2` 
MODIFY COLUMN `date` DATE
;

SELECT *
FROM `layoffs_staging2`
;

-- 3. Null Values or Blank Values


SELECT *
FROM `layoffs_staging2` AS `ls2`
WHERE ls2.`total_laid_off` IS NULL
AND ls2.`percentage_laid_off` IS NULL 
;

UPDATE `layoffs_staging2` as `ls2`
SET ls2.`industry` = NULL
WHERE ls2.`industry`= ''
;

SELECT *
FROM `layoffs_staging2` AS `ls2`
WHERE ls2.`industry` IS NULL
OR ls2.`industry` = ''
;


SELECT *
FROM `layoffs_staging2` AS `ls2`
WHERE ls2.`company` LIKE 'Bally%'
;

SELECT t1.`industry`, t2.`industry`
FROM `layoffs_staging2` AS `t1`
JOIN `layoffs_staging2` AS `t2`
	ON t1.`company` = t2.`company`
WHERE (t1.`industry` IS NULL OR t1.`industry` = '')
AND t2.`industry` IS NOT NULL
;


UPDATE  `layoffs_staging2` AS `t1`
JOIN `layoffs_staging2` AS `t2`
	ON t1.`company` = t2.`company`
SET t1.`industry` = t2.`industry`
WHERE t1.`industry` IS NULL
AND t2.`industry` IS NOT NULL
;

-- 4. Remove Any Columns 

SELECT *
FROM `layoffs_staging2` AS `ls2`
;

SELECT *
FROM `layoffs_staging2` AS `ls2`
WHERE ls2.`total_laid_off` IS NULL
AND ls2.`percentage_laid_off` IS NULL 
;


DELETE
FROM `layoffs_staging2` AS `ls2`
WHERE ls2.`total_laid_off` IS NULL
AND ls2.`percentage_laid_off` IS NULL ;




SELECT *
FROM `layoffs_staging2` AS `ls2`
;

ALTER TABLE `layoffs_staging2`
DROP COLUMN `row_num`
;









