create database if not exists walmart_sales_data;

create table if not exists sales(
		invoice_id varchar(30) not null primary key,
        branch varchar(5) not null,
        city varchar(30) not null,
        customer_type varchar(30) not null,
		gender varchar(10) not null,
        product_line varchar(100) not null,
        unit_price decimal(10,2) not null,
        quantity int not null,
        VAT float(6, 4) not null,
        total decimal(12, 4) not null,
        date datetime not null,
        time time not null,
        payment_method varchar(15) not null,
        cogs decimal(10,2) not null,
        gross_margin_pct float(11, 9),
        gross_income decimal(12, 4) not null,
        rating float(2, 1)
        );
        
        
----------------------------------------------------------------------------------------------------
----------------------------- FEATURE ENGINEERING --------------------------------------------------

select time, CASE WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
				  WHEN `time` BETWEEN "12:00:00" AND "16:00:00" THEN 'Afternoon'
				  ELSE 'Evening'
				  END
				  AS time_of_day
					from sales;

ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (CASE WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
				  WHEN `time` BETWEEN "12:00:00" AND "16:00:00" THEN 'Afternoon'
				  ELSE 'Evening'
				  END
);
----------------------------------------- DAY NAME -----------------------------------------------------
SELECT date, dayname(date) FROM sales;
ALTER TABLE sales 

ADD COLUMN day_name VARCHAR(10);

UPDATE sales
set day_name = DAYNAME(date);

------------------------------------------------ MONTH NAME -------------------------------------------------------
SELECT date, monthname(date) FROM sales;
ALTER TABLE sales 

ADD COLUMN month_name VARCHAR(10);

UPDATE sales
set month_name = monthname(date);       

----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------- Generic Question ------------------------------------------------
-- 1. How many unique cities does the data have?
		SELECT DISTINCT(CITY) FROM sales;

-- 2. In which city is each branch?
		SELECT DISTINCT city, branch FROM sales;

----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- Product ------------------------------------------------------
-- 1. How many unique product lines does the data have?
        SELECT DISTINCT product_line FROM sales;
-- 2. What is the most common payment method?
		SELECT payment_method, count(payment_method) AS total_transections FROM sales
        GROUP BY payment_method
        ORDER BY count(payment_method) DESC
        LIMIT 1;
-- 3. What is the most selling product line?
		SELECT product_line, count(product_line) AS Nos_sold FROM sales
        GROUP BY product_line
        ORDER BY Nos_sold DESC
        LIMIT 1;
-- 4. What is the total revenue by month?
		SELECT month_name AS month, SUM(total) AS total_sales FROM sales
		GROUP BY month
		ORDER BY total_sales DESC
		LIMIT 1;
-- 5. What month had the largest COGS?
		SELECT month_name AS month, sum(cogs) AS COGS
		FROM sales
		GROUP BY month 
		ORDER BY COGS DESC
		LIMIT 1;
-- 6. What product line had the largest revenue?
		SELECT product_line, sum(total) AS revenue
		FROM sales
		GROUP BY product_line
		ORDER BY revenue DESC
		LIMIT 1;
-- 7. What is the city with the largest revenue?
		SELECT city, branch, sum(total) AS revenue
		FROM sales
		GROUP BY city, branch
		ORDER BY revenue DESC
		LIMIT 1;     
-- 8. What product line had the largest VAT?
		SELECT product_line, AVG(VAT) AS AVG_VAT FROM sales 
		GROUP BY product_line
		ORDER BY AVG_VAT DESC
		LIMIT 1;
-- 9. Which branch sold more products than average product sold?
		SELECT branch, SUM(quantity) AS qty FROM sales
		GROUP BY branch
		HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales); 
-- 10. What is the average rating of each product line?
		SELECT product_line, ROUND(AVG(rating),2) AS avg_rating FROM sales
		GROUP BY product_line
		ORDER BY avg_rating DESC;
-- 11. What is the most common product line by gender?
		SELECT product_line, gender, COUNT(gender) AS count FROM sales
		GROUP BY product_line, gender
		ORDER BY count DESC	;
-- 12. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales.
		SELECT product_line, SUM(total) AS total_sales,
		CASE WHEN SUM(total) > (SELECT AVG(total) FROM sales) THEN 'GOOD'
		ELSE 'Bad'
		END AS Cat
		FROM sales
		GROUP BY product_line;
---------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------- SALES ---------------------------------------------------------------------
-- 1. Number of sales made in each time of the day per weekday?
	SELECT time_of_day, day_name, count(*) AS total_sales FROM sales
	GROUP BY time_of_day, day_name
    ORDER BY day_name,total_sales DESC;
-- 2. Which of the customer types brings the most revenue?
	SELECT customer_type, SUM(total) AS total_rev FROM sales
    GROUP BY customer_type
    ORDER BY total_rev DESC;
-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
		SELECT city, SUM(VAT) AS tax FROM sales
        GROUP BY city
        ORDER BY tax DESC;
-- 4. Which customer type pays the most in VAT?
		SELECT customer_type, SUM(VAT) AS VAT FROM sales
        GROUP BY customer_type
        ORDER BY VAT DESC;
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------- CUSTOMER -------------------------------------------------------------------
-- 1. How many unique customer types does the data have?
		SELECT DISTINCT customer_type FROM sales;
-- 2. How many unique payment methods does the data have?
		SELECT DISTINCT payment_method FROM sales;
-- 3. What is the most common customer type?
        SELECT customer_type, count(*) AS TOTAL FROM sales
        GROUP BY customer_type
        ORDER BY count(*) DESC;
-- 4. Which customer type buys the most?
		SELECT customer_type, SUM(total) AS total_purchase FROM sales
        GROUP BY customer_type
        ORDER BY total_purchase DESC;
-- 5. What is the gender of most of the customers?
		SELECT gender, count(*) AS total FROM sales
        GROUP BY gender
        ORDER BY total DESC;
-- 6. What is the gender distribution per branch?
		SELECT branch, gender, count(*) FROM sales
        GROUP BY gender, branch
        ORDER BY branch;
/* 
### Customer




5. What is the gender of most of the customers?

7. Which time of the day do customers give most ratings?
8. Which time of the day do customers give most ratings per branch?
9. Which day fo the week has the best avg ratings?
10. Which day of the week has the best average ratings per branch? 
*/       
        