-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;

-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transaction_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);

SELECT * FROM retail_sales
LIMIT 10;


-- COUNT ROWS
SELECT 
	COUNT(*)
FROM retail_sales;

-- Data Cleaning
-- NULL VALUES
SELECT * FROM retail_sales
WHERE 
	transaction_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- delete NULL values
DELETE FROM retail_sales
where
	transaction_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
select count(*) as total_sale from retail_sales;

-- How manny unique customers we have?
select count(distinct customer_id) as total_customer from retail_sales;
	
-- How many unique category we have?
select count(distinct category) as total_category from retail_sales;
select distinct category from retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * 
from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in
-- the month of Nov-2022.

select *
from retail_sales
where
	category ='Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
Select 
	category,
	sum(total_sale) as Net_sales,
	count(*) as total_orders
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
	ROUND(avg(age),2) as AVG_Age
from retail_sales
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select
	category,
	gender,
	count(*) as total_trans
from retail_sales
group by
	category,
	gender
order by category;

-- Q.7 Write a SQL query to calculate the average sale for each month. find out best selling month in each year.
Select 
	year,
	month,
	AVG_Sale
from
(
select
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as AVG_Sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as Rank
from retail_sales
GROUP BY YEAR, MONTH
) as t1
Where Rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
select
	customer_id,
	sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc
limit 5;

-- Q.9 Write a SQL query to find the no.of Unique customers who purchased items from each category.
select
	category,
	count(distinct customer_id) as Unique_Customer
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and no.of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
select *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as Shift
from retail_sales
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
group by shift;

--End of Project











