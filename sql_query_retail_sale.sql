  -- create database/schema
CREATE DATABASE retail_sale_project;
-- in retail sales file table, rows with null values cells are dropped.
-- mytable contain null values cells.
  /*create table */
DROP TABLE IF EXISTS mytable
CREATE TABLE mytable (
		transactions_id INT PRIMARY KEY ,
        sale_date DATE,
        sale_time	TIME,
        customer_id	INT,
        gender	VARCHAR(15),
        age	INT,
        category VARCHAR(15),	
        quantiy	INT,
        price_per_unit	FLOAT,
        cogs	FLOAT,
        total_sale FLOAT
				);
    
    -- DATA CLEANING
    
    SELECT * FROM mytable
    WHERE 
		transactions_id IS NULL
	OR
		sale_date IS NULL
    OR
		sale_time IS NULL
    OR
		customer_id IS NULL
    OR
		gender IS NULL
    OR
		category IS NULL
	OR
		quantiy IS NULL
    OR
		price_per_unit IS NULL
    OR
		cogs IS NULL
    OR
		total_sale IS NULL

DELETE FROM mytable
WHERE 
		transactions_id IS NULL
	OR
		sale_date IS NULL
    OR
		sale_time IS NULL
    OR
		customer_id IS NULL
    OR
		gender IS NULL
    OR
		category IS NULL
	OR
		price_per_unit IS NULL
    OR
		cogs IS NULL
    OR
		total_sale IS NULL
	OR
		quantiy IS NULL
        
-- DATA EXPLORATION 

How many sales we have?
SELECT COUNT(*) as total_sales FROM mytable

How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) FROM mytable

How many category they have?
SELECT DISTINCT category FROM mytable
SELECT COUNT(DISTINCT category) FROM mytable

-- Data Analysis & Business key problems & answers

 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05.
    SELECT * FROM mytable
    WHERE sale_date = '2022-11-05'
    
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
the quantity sold is more than 2 in the month of Nov-2022.
	SELECT * FROM mytable
    WHERE category = 'Clothing'
    AND 
    sale_date BETWEEN '2022-11-1' AND '2022-11-30'
    AND 
    quantiy > 2
	ORDER BY quantiy ASC; 
   
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
	SELECT 
		category, 
        SUM(total_sale) 
    FROM mytable
    GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	category,
    ROUND(AVG(age),2) AS average_age
FROM mytable
WHERE 
	category = 'Beauty';
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM mytable
WHERE total_sale > 1000
ORDER BY total_sale ASC;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by 
each gender in each category.
SELECT
	COUNT(transactions_id) AS total_transactions,
    gender,
    category
FROM mytable
GROUP BY 2,3
ORDER BY 2;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT * FROM (
	SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS sequence
	FROM mytable
	GROUP BY 1,2
	-- ORDER BY 1,3 DESC
) as t1
WHERE sequence = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT
	customer_id, SUM(total_sale) AS total_sale
FROM mytable
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
    COUNT(DISTINCT customer_id) as customer
FROM mytable
GROUP BY 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12,Afternoon Between 12 & 17, Evening >17).
-- method 1

WITH hourly_sale AS
(
SELECT *,
	CASE
		WHEN sale_time < 12 THEN "morning"
        WHEN sale_time between 12 AND 17 THEN "afternoon"
        ELSE "evening"
        END as shift
 FROM mytable
)
SELECT 
shift, count(*) as total_orders
FROM hourly_sale
GROUP BY shift

-- method 2

WITH hourly_sale AS
(
SELECT *,
	CASE
		WHEN HOUR(sale_time) < 12 THEN "morning"
        WHEN HOUR(sale_time) between 12 AND 17 THEN "afternoon"
        ELSE "evening"
        END as shift
 FROM mytable
)
SELECT 
shift, COUNT(transactions_id) as total_orders
FROM hourly_sale
GROUP BY shift

-- method 3

WITH hourly_sale AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN "morning"
        WHEN EXTRACT(HOUR FROM sale_time) between 12 AND 17 THEN "afternoon"
        ELSE "evening"
        END as shift
 FROM mytable
)
SELECT 
shift, count(*) as total_orders
FROM hourly_sale
GROUP BY 1

--End of Project