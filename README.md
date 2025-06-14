# Retail Sales Analysis SQL Project

## Project Overview

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sale_project`.
- **Table Creation**: A table named `mytable` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_sale_project;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
Data Exploration

How many sales we have?
SELECT COUNT(*) as total_sales FROM mytable;

How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) FROM mytable;

How many category they have?
SELECT DISTINCT category FROM mytable;
SELECT COUNT(DISTINCT category) FROM mytable;

- Data Cleaning-

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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * FROM mytable
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022**:
```sql
	SELECT * FROM mytable
    WHERE category = 'Clothing'
    AND 
    sale_date BETWEEN '2022-11-1' AND '2022-11-30'
    AND 
    quantiy > 2
	ORDER BY quantiy ASC; 
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
		category, 
        SUM(total_sale) AS total_sale,
        COUNT(*) AS total_orders
    FROM mytable
    GROUP BY 1;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
	category,
    ROUND(AVG(age),2) AS average_age
FROM mytable
WHERE 
	category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM mytable
WHERE total_sale > 1000
ORDER BY total_sale ASC;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT
	COUNT(transactions_id) AS total_transactions,
    gender,
    category
FROM mytable
GROUP BY 2,3
ORDER BY 2;

```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT
	customer_id, SUM(total_sale) AS total_sale
FROM mytable
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
	category,
    COUNT(DISTINCT customer_id) as customer
FROM mytable
GROUP BY 1;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
