-- 07_advanced_queries.sql
-- Advanced SQL Techniques and Functions

-- =============================================
-- LESSON 7: AGGREGATE FUNCTIONS AND GROUPING
-- =============================================

/*
Aggregate functions perform calculations on groups of rows:
COUNT, SUM, AVG, MIN, MAX, STRING_AGG, etc.
GROUP BY groups rows with the same values
HAVING filters groups (like WHERE but for groups)
*/

-- =============================================
-- BASIC AGGREGATE FUNCTIONS
-- =============================================

-- Count total number of books
SELECT COUNT(*) AS total_books FROM books;

-- Count non-NULL values in a column
SELECT COUNT(birth_year) AS authors_with_birth_year FROM authors;

-- Count distinct values
SELECT COUNT(DISTINCT nationality) AS unique_nationalities FROM authors;

-- Sum, average, min, max of prices
SELECT 
    COUNT(*) AS book_count,
    SUM(price) AS total_value,
    AVG(price) AS average_price,
    MIN(price) AS cheapest,
    MAX(price) AS most_expensive,
    ROUND(AVG(price), 2) AS avg_price_rounded
FROM books;

-- =============================================
-- GROUP BY - GROUPING DATA
-- =============================================

-- Count books by genre
SELECT 
    genre,
    COUNT(*) AS book_count,
    AVG(price) AS avg_price
FROM books 
GROUP BY genre
ORDER BY book_count DESC;

-- Count authors by nationality
SELECT 
    nationality,
    COUNT(*) AS author_count
FROM authors 
WHERE nationality IS NOT NULL
GROUP BY nationality
ORDER BY author_count DESC;

-- Order statistics by customer
SELECT 
    customer_id,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_spent,
    AVG(total_amount) AS avg_order_value,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM orders 
GROUP BY customer_id
ORDER BY total_spent DESC;

-- =============================================
-- HAVING CLAUSE - FILTERING GROUPS
-- =============================================

-- Find genres with more than 1 book
SELECT 
    genre,
    COUNT(*) AS book_count
FROM books 
GROUP BY genre
HAVING COUNT(*) > 1;

-- Find customers who have spent more than $25
SELECT 
    customer_id,
    SUM(total_amount) AS total_spent
FROM orders 
GROUP BY customer_id
HAVING SUM(total_amount) > 25
ORDER BY total_spent DESC;

-- Authors who have written books in multiple genres
SELECT 
    a.first_name || ' ' || a.last_name AS author_name,
    COUNT(DISTINCT b.genre) AS genre_count,
    STRING_AGG(DISTINCT b.genre, ', ') AS genres
FROM authors a
INNER JOIN books b ON a.author_id = b.author_id
GROUP BY a.author_id, a.first_name, a.last_name
HAVING COUNT(DISTINCT b.genre) > 1;

-- =============================================
-- WINDOW FUNCTIONS
-- =============================================

-- Rank books by price within each genre
SELECT 
    title,
    genre,
    price,
    RANK() OVER (PARTITION BY genre ORDER BY price DESC) AS price_rank
FROM books
ORDER BY genre, price_rank;

-- Running total of order amounts
SELECT 
    order_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (ORDER BY order_date) AS running_total
FROM orders
ORDER BY order_date;

-- Compare each book's price to the average in its genre
SELECT 
    title,
    genre,
    price,
    ROUND(AVG(price) OVER (PARTITION BY genre), 2) AS genre_avg_price,
    ROUND(price - AVG(price) OVER (PARTITION BY genre), 2) AS price_difference
FROM books
ORDER BY genre, price DESC;

-- Row numbers and rankings
SELECT 
    title,
    price,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS row_num,
    RANK() OVER (ORDER BY price DESC) AS rank_pos,
    DENSE_RANK() OVER (ORDER BY price DESC) AS dense_rank_pos
FROM books;

-- =============================================
-- ADVANCED STRING FUNCTIONS
-- =============================================

-- String aggregation
SELECT 
    nationality,
    STRING_AGG(first_name || ' ' || last_name, ', ' ORDER BY last_name) AS authors
FROM authors 
WHERE nationality IS NOT NULL
GROUP BY nationality;

-- String manipulation
SELECT 
    title,
    LENGTH(title) AS title_length,
    UPPER(title) AS title_upper,
    LOWER(title) AS title_lower,
    SUBSTRING(title, 1, 10) AS title_short,
    POSITION('the' IN LOWER(title)) AS contains_the,
    REPLACE(title, ' ', '_') AS title_with_underscores
FROM books;

-- Pattern matching with regular expressions
SELECT 
    title,
    CASE 
        WHEN title ~ '[0-9]' THEN 'Contains numbers'
        WHEN title ~ '^[A-Z][a-z]+$' THEN 'Single capitalized word'
        ELSE 'Other pattern'
    END AS title_pattern
FROM books;

-- =============================================
-- DATE AND TIME FUNCTIONS
-- =============================================

-- Date arithmetic and extraction
SELECT 
    first_name || ' ' || last_name AS name,
    registration_date,
    EXTRACT(YEAR FROM registration_date) AS reg_year,
    EXTRACT(MONTH FROM registration_date) AS reg_month,
    EXTRACT(DOW FROM registration_date) AS day_of_week, -- 0=Sunday
    AGE(CURRENT_DATE, registration_date) AS time_since_registration,
    registration_date + INTERVAL '1 year' AS one_year_later
FROM customers;

-- Orders by month
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    COUNT(*) AS order_count,
    SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY year, month;

-- =============================================
-- CONDITIONAL LOGIC WITH CASE
-- =============================================

-- Categorize books by price
SELECT 
    title,
    price,
    CASE 
        WHEN price < 12 THEN 'Budget'
        WHEN price < 16 THEN 'Standard'  
        ELSE 'Premium'
    END AS price_category
FROM books
ORDER BY price;

-- Customer loyalty levels
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count,
    SUM(o.total_amount) AS total_spent,
    CASE 
        WHEN COUNT(o.order_id) = 0 THEN 'No Orders'
        WHEN COUNT(o.order_id) = 1 THEN 'New Customer'
        WHEN COUNT(o.order_id) <= 3 THEN 'Regular'
        ELSE 'VIP'
    END AS loyalty_level
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC NULLS LAST;

-- =============================================
-- SUBQUERIES
-- =============================================

-- Scalar subquery (returns single value)
SELECT 
    title,
    price,
    price - (SELECT AVG(price) FROM books) AS price_vs_average
FROM books;

-- Correlated subquery
SELECT 
    title,
    price,
    (SELECT COUNT(*) 
     FROM books b2 
     WHERE b2.genre = books.genre AND b2.price > books.price) AS books_more_expensive_in_genre
FROM books
ORDER BY genre, price DESC;

-- EXISTS subquery
SELECT 
    a.first_name || ' ' || a.last_name AS author_name
FROM authors a
WHERE EXISTS (
    SELECT 1 FROM books b 
    WHERE b.author_id = a.author_id 
    AND b.price > 15
);

-- =============================================
-- COMMON TABLE EXPRESSIONS (CTEs)
-- =============================================

-- Simple CTE
WITH expensive_books AS (
    SELECT * FROM books WHERE price > 15
)
SELECT 
    eb.title,
    a.first_name || ' ' || a.last_name AS author_name
FROM expensive_books eb
JOIN authors a ON eb.author_id = a.author_id;

-- Multiple CTEs
WITH 
author_stats AS (
    SELECT 
        author_id,
        COUNT(*) AS book_count,
        AVG(price) AS avg_price
    FROM books 
    GROUP BY author_id
),
customer_stats AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count,
        SUM(total_amount) AS total_spent
    FROM orders 
    GROUP BY customer_id
)
SELECT 
    a.first_name || ' ' || a.last_name AS author_name,
    ast.book_count,
    ast.avg_price
FROM authors a
JOIN author_stats ast ON a.author_id = ast.author_id
WHERE ast.book_count > 1;

-- Recursive CTE (advanced example)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;

-- =============================================
-- ADVANCED ANALYTICS
-- =============================================

-- Percentiles and statistical functions
SELECT 
    genre,
    COUNT(*) AS book_count,
    MIN(price) AS min_price,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price) AS q1_price,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS median_price,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price) AS q3_price,
    MAX(price) AS max_price,
    STDDEV(price) AS price_stddev
FROM books 
GROUP BY genre
ORDER BY book_count DESC;

-- Moving averages with window functions
SELECT 
    order_date,
    total_amount,
    AVG(total_amount) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3_orders
FROM orders
ORDER BY order_date;

-- =============================================
-- PRACTICAL BUSINESS QUERIES
-- =============================================

-- Monthly sales report
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', o.order_date) AS month,
        COUNT(DISTINCT o.order_id) AS orders,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        SUM(oi.quantity * oi.price_per_item) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT 
    month,
    orders,
    unique_customers,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_change
FROM monthly_sales
ORDER BY month;

-- Customer segmentation
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS name,
        COUNT(o.order_id) AS order_frequency,
        SUM(o.total_amount) AS monetary_value,
        MAX(o.order_date) AS last_order_date,
        CURRENT_DATE - MAX(o.order_date) AS days_since_last_order
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT 
    name,
    order_frequency,
    monetary_value,
    days_since_last_order,
    CASE 
        WHEN order_frequency >= 3 AND monetary_value > 40 THEN 'Champions'
        WHEN order_frequency >= 2 AND monetary_value > 25 THEN 'Loyal Customers'
        WHEN order_frequency = 1 AND days_since_last_order <= 30 THEN 'New Customers'
        WHEN days_since_last_order > 90 THEN 'At Risk'
        ELSE 'Potential Loyalists'
    END AS customer_segment
FROM customer_metrics
ORDER BY monetary_value DESC NULLS LAST;

-- =============================================
-- KEY CONCEPTS LEARNED
-- =============================================

/*
1. Aggregate Functions: COUNT, SUM, AVG, MIN, MAX
2. GROUP BY for grouping data
3. HAVING for filtering groups
4. Window Functions: RANK, ROW_NUMBER, PARTITION BY
5. String Functions: STRING_AGG, LENGTH, SUBSTRING, etc.
6. Date Functions: EXTRACT, AGE, DATE_TRUNC
7. CASE statements for conditional logic
8. Subqueries: scalar, correlated, EXISTS
9. CTEs (Common Table Expressions)
10. Advanced analytics and business intelligence queries
*/

-- =============================================
-- PRACTICE EXERCISES
-- =============================================

/*
Write queries for these advanced scenarios:

1. Find the best-selling book in each genre
2. Calculate year-over-year sales growth
3. Find customers who haven't ordered in the last 6 months
4. Rank authors by total revenue generated
5. Find the most popular book each month
6. Calculate the average time between customer orders
7. Find books that are priced above the average for their genre
8. Create a running total of monthly sales
9. Find the top 3 customers in each geographic region (if we had regions)
10. Calculate customer lifetime value and retention rates

Bonus: Create a comprehensive dashboard query that shows:
- Total sales this month vs last month
- Top 5 customers by spending
- Most popular books
- Author performance metrics
*/