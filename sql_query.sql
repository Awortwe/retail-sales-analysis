CREATE DATABASE IF NOT EXISTS retail_db;
USE retail_db;

CREATE TABLE IF NOT EXISTS sales_retail
(
	transaction_id INT PRIMARY KEY NOT NULL,
    sale_date DATE NOT NULL,
    sales_time TIME NOT NULL,
    customer_id INT NOT NULL,
    gender VARCHAR(15) NOT NULL,
    age INT NOT NULL,
    category VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    price_per_unit FLOAT NOT NULL,
    cogs FLOAT NOT NULL,
    total_sale FLOAT NOT NULL
);

SELECT COUNT(*)`Total Sales`
FROM sales_retail;

SELECT COUNT(DISTINCT customer_id)`Number of Customers`
FROM sales_retail;

SELECT DISTINCT category 
FROM sales_retail;

SELECT * 
FROM sales_retail;

SELECT * 
FROM sales_retail
WHERE transaction_id IS NULL OR sale_date IS NULL
OR sales_time IS NULL OR customer_id IS NULL OR
gender IS NULL OR age IS NULL OR category IS NULL OR 
quantity IS NULL OR price_per_unit IS NULL OR
cogs IS NULL OR total_sale IS NULL;


-- Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM sales_retail
WHERE
sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT * 
FROM 
sales_retail
WHERE category = 'Clothing' AND quantity > 3
AND MONTH(sale_date) = 11 and YEAR(sale_date) = 2022;

-- Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, 
FORMAT(SUM(total_sale),2)`Total Sales` 
FROM sales_retail
GROUP BY category
ORDER BY `Total Sales` DESC;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT customer_id, ROUND(AVG(age))`Average Age` 
FROM sales_retail
WHERE category = 'Beauty'
GROUP BY customer_id
ORDER BY customer_id;

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM sales_retail
WHERE total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT  gender, category, COUNT(transaction_id)`Total Transaction`
FROM sales_retail
GROUP BY gender, category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT `Month`, `Year`, `Average Sale`
FROM
(SELECT 
	MONTHNAME(sale_date)`Month`,
    YEAR(sale_date)`Year`,
    FORMAT(AVG(total_sale),2)`Average Sale`,
    RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) `rank`
    FROM sales_retail
    GROUP BY 1,2) AS t1
WHERE `rank` = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, FORMAT(SUM(total_sale),2)`Total Sale`
FROM sales_retail
GROUP BY customer_id
ORDER BY `Total Sale` DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,
COUNT(DISTINCT customer_id) `customers` 
FROM sales_retail
GROUP BY category
ORDER BY `customers`;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale AS
(SELECT *,
CASE
WHEN HOUR(sales_time) < 12 THEN 'Monday'
WHEN HOUR(sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN HOUR(sales_time) > 17 THEN 'Evening'
END AS shift
FROM sales_retail)
SELECT shift,
count(*) AS total_orders
FROM hourly_sale
GROUP BY shift;






