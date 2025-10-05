-- 06_relationships.sql
-- Working with Related Tables and JOINs

-- =============================================
-- LESSON 6: RELATIONSHIPS AND JOINS
-- =============================================

/*
Relationships connect tables together:
- One-to-Many: One author can have many books
- Many-to-Many: Books can be in many orders, orders can have many books
- One-to-One: Each customer has one primary address (hypothetical)

JOINs allow us to query multiple related tables at once.
*/

-- =============================================
-- UNDERSTANDING FOREIGN KEYS
-- =============================================

-- Let's see our current relationships:
-- books.author_id → authors.author_id
-- orders.customer_id → customers.customer_id  
-- order_items.order_id → orders.order_id
-- order_items.book_id → books.book_id

-- View table relationships
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY';

-- =============================================
-- INNER JOIN - MOST COMMON JOIN
-- =============================================

-- Get books with their author names
SELECT 
    books.title,
    books.price,
    authors.first_name,
    authors.last_name
FROM books
INNER JOIN authors ON books.author_id = authors.author_id;

-- Using table aliases to make queries shorter
SELECT 
    b.title,
    b.price,
    a.first_name || ' ' || a.last_name AS author_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id;

-- Get orders with customer information
SELECT 
    o.order_id,
    o.order_date,
    o.total_amount,
    c.first_name,
    c.last_name,
    c.email
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- =============================================
-- LEFT JOIN - INCLUDE ALL FROM LEFT TABLE
-- =============================================

-- Get all authors, even if they don't have books
SELECT 
    a.first_name,
    a.last_name,
    b.title
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
ORDER BY a.last_name;

-- Find authors with no books
SELECT 
    a.first_name,
    a.last_name
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
WHERE b.book_id IS NULL;

-- Get all customers, including those who haven't ordered
SELECT 
    c.first_name,
    c.last_name,
    c.email,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.last_name;

-- =============================================
-- RIGHT JOIN - INCLUDE ALL FROM RIGHT TABLE
-- =============================================

-- Same as LEFT JOIN but reversed (less commonly used)
SELECT 
    a.first_name,
    a.last_name,
    b.title
FROM books b
RIGHT JOIN authors a ON b.author_id = a.author_id;

-- =============================================
-- FULL OUTER JOIN - INCLUDE ALL FROM BOTH TABLES
-- =============================================

-- Get all authors and all books, whether they match or not
SELECT 
    a.first_name,
    a.last_name,
    b.title
FROM authors a
FULL OUTER JOIN books b ON a.author_id = b.author_id;

-- =============================================
-- MULTIPLE JOINS
-- =============================================

-- Get complete order information: customer, order, and items
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_date,
    b.title,
    oi.quantity,
    oi.price_per_item,
    (oi.quantity * oi.price_per_item) AS line_total
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN books b ON oi.book_id = b.book_id
ORDER BY o.order_date, c.last_name;

-- Get books with author info and order statistics
SELECT 
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    b.price,
    COUNT(oi.order_item_id) AS times_ordered,
    SUM(oi.quantity) AS total_sold
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
LEFT JOIN order_items oi ON b.book_id = oi.book_id
GROUP BY b.book_id, b.title, a.first_name, a.last_name, b.price
ORDER BY total_sold DESC;

-- =============================================
-- SELF JOIN - JOIN TABLE TO ITSELF
-- =============================================

-- Example: Find authors from the same country
SELECT 
    a1.first_name || ' ' || a1.last_name AS author1,
    a2.first_name || ' ' || a2.last_name AS author2,
    a1.nationality
FROM authors a1
INNER JOIN authors a2 ON a1.nationality = a2.nationality
WHERE a1.author_id < a2.author_id  -- Avoid duplicates
ORDER BY a1.nationality;

-- =============================================
-- JOIN CONDITIONS AND FILTERING
-- =============================================

-- Join with additional WHERE conditions
SELECT 
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    b.price
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
WHERE b.price > 12.00
AND a.nationality = 'British'
ORDER BY b.price DESC;

-- Using ON vs WHERE with JOINs
-- ON - conditions for the join itself
-- WHERE - filters the final result

-- This gives different results:
SELECT 
    a.first_name,
    a.last_name,
    b.title
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id 
    AND b.price > 15.00;  -- Join condition

-- vs this:
SELECT 
    a.first_name,
    a.last_name,
    b.title
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
WHERE b.price > 15.00;  -- Filter condition

-- =============================================
-- PRACTICAL EXAMPLES
-- =============================================

-- Example 1: Customer order summary
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.order_id) AS number_of_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS average_order_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- Example 2: Most popular books
SELECT 
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    COUNT(oi.order_item_id) AS order_count,
    SUM(oi.quantity) AS total_quantity_sold
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
LEFT JOIN order_items oi ON b.book_id = oi.book_id
GROUP BY b.book_id, b.title, a.first_name, a.last_name
HAVING COUNT(oi.order_item_id) > 0
ORDER BY total_quantity_sold DESC;

-- Example 3: Orders with full details
SELECT 
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_date,
    o.status,
    STRING_AGG(b.title, ', ') AS books_ordered,
    o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN books b ON oi.book_id = b.book_id
GROUP BY o.order_id, c.first_name, c.last_name, o.order_date, o.status, o.total_amount
ORDER BY o.order_date DESC;

-- =============================================
-- SUBQUERIES VS JOINS
-- =============================================

-- Find books by British authors (using JOIN)
SELECT b.title, b.price
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
WHERE a.nationality = 'British';

-- Same query using subquery
SELECT title, price
FROM books
WHERE author_id IN (
    SELECT author_id 
    FROM authors 
    WHERE nationality = 'British'
);

-- Find customers who have never ordered (using LEFT JOIN)
SELECT c.first_name, c.last_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- Same query using subquery
SELECT first_name, last_name
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id 
    FROM orders 
    WHERE customer_id IS NOT NULL
);

-- =============================================
-- PERFORMANCE CONSIDERATIONS
-- =============================================

-- JOINs are generally faster than subqueries for simple cases
-- Use EXPLAIN to see query execution plans
EXPLAIN SELECT b.title, a.first_name, a.last_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id;

-- Indexes on foreign key columns improve JOIN performance
-- CREATE INDEX idx_books_author_id ON books(author_id);

-- =============================================
-- KEY CONCEPTS LEARNED
-- =============================================

/*
1. INNER JOIN - only matching records from both tables
2. LEFT JOIN - all records from left table, matching from right
3. RIGHT JOIN - all records from right table, matching from left  
4. FULL OUTER JOIN - all records from both tables
5. Multiple JOINs - connecting 3+ tables
6. Self JOIN - joining table to itself
7. Table aliases for cleaner queries
8. ON vs WHERE clauses in JOINs
9. JOINs vs subqueries
10. Performance considerations
*/

-- =============================================
-- PRACTICE EXERCISES
-- =============================================

/*
Write queries for these questions:

1. List all books with their authors' full names and nationalities
2. Find all customers who have placed orders, with order count
3. Show all authors and how many books each has written (include 0)
4. Find the total revenue generated by each author's books
5. List all orders with customer names and the books in each order
6. Find customers who have ordered books by British authors
7. Show authors who have written books in multiple genres
8. Find the most expensive book by each author
9. List customers who have spent more than $50 total
10. Find books that have never been ordered

Bonus: Try writing each query using both JOINs and subqueries!
*/