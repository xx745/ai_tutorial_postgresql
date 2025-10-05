-- 08_practice_exercises.sql
-- Hands-on Exercises and Real-World Scenarios

-- =============================================
-- PRACTICE EXERCISES WITH SOLUTIONS
-- =============================================

/*
This file contains exercises of increasing difficulty.
Try to solve each one before looking at the solution!

Work through these in order - they build on each other.
*/

-- =============================================
-- BEGINNER EXERCISES
-- =============================================

-- Exercise 1: Find all books with more than 300 pages
-- Your solution here:


-- SOLUTION:
-- SELECT title, pages FROM books WHERE pages > 300;

-- =============================================

-- Exercise 2: List authors born in the 20th century (1901-2000)
-- Your solution here:


-- SOLUTION:
-- SELECT first_name, last_name, birth_year 
-- FROM authors 
-- WHERE birth_year BETWEEN 1901 AND 2000;

-- =============================================

-- Exercise 3: Find customers whose email contains 'gmail'
-- Your solution here:


-- SOLUTION:
-- SELECT first_name, last_name, email 
-- FROM customers 
-- WHERE email LIKE '%gmail%';

-- =============================================

-- Exercise 4: Get the 3 most expensive books
-- Your solution here:


-- SOLUTION:
-- SELECT title, price FROM books 
-- ORDER BY price DESC LIMIT 3;

-- =============================================

-- Exercise 5: Count how many books each genre has
-- Your solution here:


-- SOLUTION:
-- SELECT genre, COUNT(*) as book_count 
-- FROM books 
-- GROUP BY genre 
-- ORDER BY book_count DESC;

-- =============================================
-- INTERMEDIATE EXERCISES  
-- =============================================

-- Exercise 6: Find books with their author names
-- Your solution here:


-- SOLUTION:
-- SELECT b.title, a.first_name || ' ' || a.last_name AS author_name
-- FROM books b
-- JOIN authors a ON b.author_id = a.author_id;

-- =============================================

-- Exercise 7: Find customers who have never placed an order
-- Your solution here:


-- SOLUTION:
-- SELECT c.first_name, c.last_name 
-- FROM customers c
-- LEFT JOIN orders o ON c.customer_id = o.customer_id
-- WHERE o.customer_id IS NULL;

-- =============================================

-- Exercise 8: Calculate total revenue by genre
-- Your solution here:


-- SOLUTION:
-- SELECT b.genre, SUM(oi.quantity * oi.price_per_item) AS total_revenue
-- FROM books b
-- JOIN order_items oi ON b.book_id = oi.book_id
-- GROUP BY b.genre
-- ORDER BY total_revenue DESC;

-- =============================================

-- Exercise 9: Find authors who have written more than one book
-- Your solution here:


-- SOLUTION:
-- SELECT a.first_name, a.last_name, COUNT(b.book_id) AS book_count
-- FROM authors a
-- JOIN books b ON a.author_id = b.author_id
-- GROUP BY a.author_id, a.first_name, a.last_name
-- HAVING COUNT(b.book_id) > 1;

-- =============================================

-- Exercise 10: Find the average order value for each customer
-- Your solution here:


-- SOLUTION:
-- SELECT c.first_name, c.last_name, AVG(o.total_amount) AS avg_order_value
-- FROM customers c
-- JOIN orders o ON c.customer_id = o.customer_id
-- GROUP BY c.customer_id, c.first_name, c.last_name;

-- =============================================
-- ADVANCED EXERCISES
-- =============================================

-- Exercise 11: Find the best-selling book (by quantity sold)
-- Your solution here:


-- SOLUTION:
-- SELECT b.title, SUM(oi.quantity) AS total_sold
-- FROM books b
-- JOIN order_items oi ON b.book_id = oi.book_id
-- GROUP BY b.book_id, b.title
-- ORDER BY total_sold DESC
-- LIMIT 1;

-- =============================================

-- Exercise 12: Calculate monthly sales totals
-- Your solution here:


-- SOLUTION:
-- SELECT 
--     EXTRACT(YEAR FROM o.order_date) AS year,
--     EXTRACT(MONTH FROM o.order_date) AS month,
--     SUM(o.total_amount) AS monthly_total
-- FROM orders o
-- GROUP BY EXTRACT(YEAR FROM o.order_date), EXTRACT(MONTH FROM o.order_date)
-- ORDER BY year, month;

-- =============================================

-- Exercise 13: Find customers who bought books by British authors
-- Your solution here:


-- SOLUTION:
-- SELECT DISTINCT c.first_name, c.last_name
-- FROM customers c
-- JOIN orders o ON c.customer_id = o.customer_id
-- JOIN order_items oi ON o.order_id = oi.order_id
-- JOIN books b ON oi.book_id = b.book_id
-- JOIN authors a ON b.author_id = a.author_id
-- WHERE a.nationality = 'British';

-- =============================================

-- Exercise 14: Rank books by price within each genre
-- Your solution here:


-- SOLUTION:
-- SELECT 
--     title,
--     genre, 
--     price,
--     RANK() OVER (PARTITION BY genre ORDER BY price DESC) AS price_rank
-- FROM books
-- ORDER BY genre, price_rank;

-- =============================================

-- Exercise 15: Find authors whose books have all been ordered
-- Your solution here:


-- SOLUTION:
-- SELECT a.first_name, a.last_name
-- FROM authors a
-- JOIN books b ON a.author_id = b.author_id
-- WHERE NOT EXISTS (
--     SELECT 1 FROM books b2 
--     WHERE b2.author_id = a.author_id 
--     AND b2.book_id NOT IN (SELECT DISTINCT book_id FROM order_items)
-- )
-- GROUP BY a.author_id, a.first_name, a.last_name;

-- =============================================
-- REAL-WORLD SCENARIOS
-- =============================================

-- Scenario 1: E-commerce Analytics Dashboard
-- Create a query that shows key business metrics

SELECT 
    'Total Revenue' AS metric,
    SUM(oi.quantity * oi.price_per_item)::TEXT AS value
FROM order_items oi
UNION ALL
SELECT 
    'Total Orders',
    COUNT(*)::TEXT
FROM orders
UNION ALL
SELECT 
    'Active Customers',
    COUNT(DISTINCT customer_id)::TEXT
FROM orders
UNION ALL
SELECT 
    'Average Order Value',
    ROUND(AVG(total_amount), 2)::TEXT
FROM orders
UNION ALL
SELECT 
    'Books in Catalog',
    COUNT(*)::TEXT
FROM books;

-- =============================================

-- Scenario 2: Inventory Management
-- Find books that might need restocking (haven't been ordered recently)

WITH recent_orders AS (
    SELECT DISTINCT book_id
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '30 days'
)
SELECT 
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    b.price,
    b.genre
FROM books b
JOIN authors a ON b.author_id = a.author_id
LEFT JOIN recent_orders ro ON b.book_id = ro.book_id
WHERE ro.book_id IS NULL
ORDER BY b.price DESC;

-- =============================================

-- Scenario 3: Customer Segmentation for Marketing
-- Segment customers based on purchase behavior

WITH customer_stats AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS name,
        c.email,
        COUNT(o.order_id) AS order_count,
        SUM(o.total_amount) AS total_spent,
        MAX(o.order_date) AS last_order_date,
        MIN(o.order_date) AS first_order_date
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email
)
SELECT 
    name,
    email,
    order_count,
    total_spent,
    CASE 
        WHEN order_count = 0 THEN 'Never Purchased'
        WHEN order_count = 1 THEN 'One-Time Buyer'
        WHEN total_spent > 50 THEN 'High Value'
        WHEN last_order_date > CURRENT_DATE - INTERVAL '30 days' THEN 'Recent Active'
        WHEN last_order_date < CURRENT_DATE - INTERVAL '90 days' THEN 'At Risk'
        ELSE 'Regular'
    END AS segment,
    last_order_date
FROM customer_stats
ORDER BY 
    CASE 
        WHEN order_count = 0 THEN 1
        WHEN order_count = 1 THEN 2  
        WHEN total_spent > 50 THEN 3
        WHEN last_order_date > CURRENT_DATE - INTERVAL '30 days' THEN 4
        WHEN last_order_date < CURRENT_DATE - INTERVAL '90 days' THEN 5
        ELSE 6
    END,
    total_spent DESC NULLS LAST;

-- =============================================

-- Scenario 4: Author Royalty Report
-- Calculate how much each author has earned from book sales

SELECT 
    a.first_name || ' ' || a.last_name AS author_name,
    COUNT(DISTINCT b.book_id) AS books_published,
    SUM(oi.quantity) AS total_books_sold,
    SUM(oi.quantity * oi.price_per_item) AS gross_revenue,
    ROUND(SUM(oi.quantity * oi.price_per_item) * 0.15, 2) AS author_royalty_15_percent
FROM authors a
JOIN books b ON a.author_id = b.author_id
LEFT JOIN order_items oi ON b.book_id = oi.book_id
GROUP BY a.author_id, a.first_name, a.last_name
ORDER BY gross_revenue DESC NULLS LAST;

-- =============================================

-- Scenario 5: Seasonal Analysis
-- Analyze sales patterns by month to identify seasonal trends

SELECT 
    EXTRACT(MONTH FROM o.order_date) AS month,
    TO_CHAR(DATE '2023-01-01' + (EXTRACT(MONTH FROM o.order_date) - 1) * INTERVAL '1 month', 'Month') AS month_name,
    COUNT(o.order_id) AS orders,
    SUM(o.total_amount) AS revenue,
    AVG(o.total_amount) AS avg_order_value,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM orders o
GROUP BY EXTRACT(MONTH FROM o.order_date)
ORDER BY month;

-- =============================================
-- CHALLENGE PROBLEMS
-- =============================================

/*
These are advanced problems that combine multiple concepts:

1. Market Basket Analysis
   Find books that are frequently bought together

2. Customer Lifetime Value
   Calculate the projected value of each customer

3. Churn Prediction
   Identify customers likely to stop buying

4. Price Optimization
   Analyze the relationship between price and sales volume

5. Recommendation Engine
   Find books similar to what a customer has already bought

Try to solve these using the techniques you've learned!
*/

-- Example: Simple Market Basket Analysis
WITH order_pairs AS (
    SELECT 
        oi1.book_id AS book1_id,
        oi2.book_id AS book2_id,
        COUNT(*) AS times_bought_together
    FROM order_items oi1
    JOIN order_items oi2 ON oi1.order_id = oi2.order_id
    WHERE oi1.book_id < oi2.book_id  -- Avoid duplicates
    GROUP BY oi1.book_id, oi2.book_id
    HAVING COUNT(*) > 1  -- Only pairs bought together multiple times
)
SELECT 
    b1.title AS book1,
    b2.title AS book2,
    op.times_bought_together
FROM order_pairs op
JOIN books b1 ON op.book1_id = b1.book_id
JOIN books b2 ON op.book2_id = b2.book_id
ORDER BY op.times_bought_together DESC;

-- =============================================
-- PERFORMANCE EXERCISES
-- =============================================

/*
These exercises focus on query optimization:

1. Add appropriate indexes to improve query performance
2. Rewrite subqueries as JOINs for better performance  
3. Use EXPLAIN to analyze query execution plans
4. Optimize queries that scan large result sets

Example index creation:
CREATE INDEX idx_books_author_id ON books(author_id);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
*/

-- =============================================
-- DATA QUALITY EXERCISES
-- =============================================

-- Find potential data quality issues:

-- 1. Books without prices
SELECT * FROM books WHERE price IS NULL OR price <= 0;

-- 2. Authors without books
SELECT a.* FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
WHERE b.author_id IS NULL;

-- 3. Orders with no items
SELECT o.* FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;

-- 4. Inconsistent data (order total vs sum of items)
SELECT 
    o.order_id,
    o.total_amount AS recorded_total,
    SUM(oi.quantity * oi.price_per_item) AS calculated_total,
    ABS(o.total_amount - SUM(oi.quantity * oi.price_per_item)) AS difference
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.total_amount
HAVING ABS(o.total_amount - SUM(oi.quantity * oi.price_per_item)) > 0.01;

-- =============================================
-- FINAL PROJECT IDEAS
-- =============================================

/*
Create comprehensive reports for these scenarios:

1. Monthly Business Report
   - Revenue trends, top products, customer acquisition

2. Author Performance Dashboard  
   - Sales by author, genre analysis, royalty calculations

3. Customer Analytics Report
   - Segmentation, lifetime value, churn analysis

4. Inventory Management System
   - Stock levels, reorder points, sales velocity

5. Financial Summary
   - P&L statement, tax calculations, regional breakdown

Use all the SQL techniques you've learned to create these reports!
*/