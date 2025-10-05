-- 05_update_delete.sql
-- Modifying and Removing Data

-- =============================================
-- LESSON 5: UPDATE AND DELETE STATEMENTS
-- =============================================

/*
UPDATE - Modifies existing data in tables
DELETE - Removes data from tables
Both can be dangerous - always use WHERE clause!
*/

-- =============================================
-- UPDATE STATEMENT BASICS
-- =============================================

-- Basic syntax: UPDATE table SET column = value WHERE condition;

-- Update a single author's nationality
UPDATE authors 
SET nationality = 'English' 
WHERE first_name = 'Jane' AND last_name = 'Austen';

-- Update multiple columns at once
UPDATE books 
SET price = 11.99, genre = 'Classic Literature'
WHERE title = 'Pride and Prejudice';

-- Update with calculations
UPDATE books 
SET price = price * 1.1  -- Increase all prices by 10%
WHERE publication_year < 1950;

-- =============================================
-- UPDATE WITH JOINS (Advanced)
-- =============================================

-- Update books to set author's full name (we'll learn JOINs properly later)
UPDATE books 
SET title = title || ' by ' || (
    SELECT first_name || ' ' || last_name 
    FROM authors 
    WHERE authors.author_id = books.author_id
)
WHERE book_id = 1;

-- Reset the title back to normal
UPDATE books 
SET title = 'Pride and Prejudice'
WHERE book_id = 1;

-- =============================================
-- UPDATE EXAMPLES
-- =============================================

-- Add area code to phone numbers that don't have them
UPDATE customers 
SET phone = '555-' || phone
WHERE phone NOT LIKE '___-____';

-- Update order status for completed orders
UPDATE orders 
SET status = 'delivered'
WHERE status = 'completed' AND order_date < NOW() - INTERVAL '7 days';

-- Update customer registration date to today if it's NULL
UPDATE customers 
SET registration_date = CURRENT_DATE
WHERE registration_date IS NULL;

-- =============================================
-- DELETE STATEMENT BASICS
-- =============================================

-- Basic syntax: DELETE FROM table WHERE condition;

-- DANGER! This would delete ALL records (no WHERE clause):
-- DELETE FROM customers;  -- DON'T DO THIS!

-- Delete a specific customer
DELETE FROM customers 
WHERE customer_id = 999;  -- Safe because this ID doesn't exist

-- Delete customers with no orders (we'll learn subqueries properly later)
DELETE FROM customers 
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id 
    FROM orders 
    WHERE customer_id IS NOT NULL
);

-- =============================================
-- SAFE DELETE PRACTICES
-- =============================================

-- Always test with SELECT first!
-- Instead of: DELETE FROM books WHERE price > 20;
-- First run: SELECT * FROM books WHERE price > 20;
SELECT * FROM books WHERE price > 20;

-- If the SELECT looks right, then run the DELETE
-- DELETE FROM books WHERE price > 20;

-- Use transactions for safety (we'll learn these later)
BEGIN;
    DELETE FROM books WHERE book_id = 999;
    -- Check if this is what you wanted
    SELECT COUNT(*) FROM books;
    -- If good: COMMIT; If bad: ROLLBACK;
ROLLBACK;  -- Undoes the delete

-- =============================================
-- DELETE WITH MULTIPLE CONDITIONS
-- =============================================

-- Delete orders that are older than 1 year and cancelled
DELETE FROM orders 
WHERE status = 'cancelled' 
AND order_date < NOW() - INTERVAL '1 year';

-- Delete books by authors who are no longer active (hypothetical)
DELETE FROM books 
WHERE author_id IN (
    SELECT author_id FROM authors 
    WHERE nationality = 'Unknown'
);

-- =============================================
-- CASCADE DELETES AND FOREIGN KEYS
-- =============================================

-- If you try to delete an author who has books, you'll get an error:
-- DELETE FROM authors WHERE author_id = 1;
-- This fails because books reference this author

-- You must delete books first, then author:
-- DELETE FROM books WHERE author_id = 1;
-- DELETE FROM authors WHERE author_id = 1;

-- Or you can set up CASCADE DELETE when creating tables:
-- REFERENCES authors(author_id) ON DELETE CASCADE

-- =============================================
-- RETURNING CLAUSE
-- =============================================

-- See what you updated/deleted
UPDATE books 
SET price = price * 0.9 
WHERE genre = 'Romance'
RETURNING book_id, title, price;

-- Delete and see what was deleted
DELETE FROM customers 
WHERE registration_date < '2020-01-01'
RETURNING customer_id, first_name, last_name;

-- =============================================
-- BULK OPERATIONS
-- =============================================

-- Update multiple records efficiently
UPDATE books 
SET genre = CASE 
    WHEN publication_year < 1900 THEN 'Classic'
    WHEN publication_year < 1950 THEN 'Early Modern'
    ELSE genre 
END;

-- Delete multiple related records
DELETE FROM order_items 
WHERE order_id IN (
    SELECT order_id FROM orders 
    WHERE status = 'cancelled'
);

-- =============================================
-- UPSERT (INSERT OR UPDATE)
-- =============================================

-- PostgreSQL's ON CONFLICT clause (UPSERT)
INSERT INTO authors (first_name, last_name, nationality)
VALUES ('William', 'Shakespeare', 'British')
ON CONFLICT (first_name, last_name) 
DO UPDATE SET nationality = EXCLUDED.nationality;

-- Note: This requires a unique constraint on (first_name, last_name)

-- =============================================
-- PRACTICAL EXAMPLES
-- =============================================

-- Example 1: Price adjustment sale
-- Reduce prices by 20% for books over $15
UPDATE books 
SET price = ROUND(price * 0.8, 2)
WHERE price > 15.00
RETURNING title, price;

-- Example 2: Clean up test data
-- Delete customers with email containing 'test'
DELETE FROM customers 
WHERE email LIKE '%test%';

-- Example 3: Update order totals
-- Recalculate order totals based on order items
UPDATE orders 
SET total_amount = (
    SELECT SUM(quantity * price_per_item)
    FROM order_items 
    WHERE order_items.order_id = orders.order_id
);

-- Example 4: Archive old orders
-- Move orders older than 2 years to completed status
UPDATE orders 
SET status = 'archived'
WHERE order_date < NOW() - INTERVAL '2 years'
AND status NOT IN ('cancelled', 'refunded');

-- =============================================
-- CONDITIONAL UPDATES
-- =============================================

-- Update only if condition is met
UPDATE customers 
SET email = LOWER(email)  -- Convert to lowercase
WHERE email != LOWER(email);  -- Only if not already lowercase

-- Update with complex logic
UPDATE books 
SET price = CASE 
    WHEN pages > 500 THEN price * 1.2  -- Increase by 20%
    WHEN pages < 200 THEN price * 0.9  -- Decrease by 10%
    ELSE price  -- Keep same
END
WHERE genre = 'Fiction';

-- =============================================
-- SAFETY TIPS
-- =============================================

/*
1. ALWAYS use WHERE clause (unless you really want to affect all rows)
2. Test with SELECT before UPDATE/DELETE
3. Use transactions for complex operations
4. Be careful with foreign key constraints
5. Use LIMIT with DELETE for large datasets
6. Consider making backups before bulk operations
7. Use RETURNING to verify what changed
*/

-- Example of safe deletion process:
-- Step 1: Count what will be affected
SELECT COUNT(*) FROM books WHERE price < 5;

-- Step 2: See the actual records
SELECT * FROM books WHERE price < 5;

-- Step 3: If it looks right, delete (uncomment to run)
-- DELETE FROM books WHERE price < 5;

-- =============================================
-- KEY CONCEPTS LEARNED
-- =============================================

/*
1. UPDATE table SET column = value WHERE condition
2. DELETE FROM table WHERE condition  
3. Updating multiple columns at once
4. Using calculations in updates
5. RETURNING clause to see changes
6. CASCADE deletes and foreign key constraints
7. UPSERT with ON CONFLICT
8. Conditional updates with CASE
9. Safety practices (SELECT first, use transactions)
10. Bulk operations for efficiency
*/

-- =============================================
-- PRACTICE EXERCISES
-- =============================================

/*
Try these exercises (be careful and use SELECT first!):

1. Update all books published before 1900 to have genre 'Classic'
2. Increase the price of all books by George Orwell by 15%
3. Update the phone number format for all customers to include dashes
4. Delete any authors where both first_name and last_name are 'Unknown'
5. Update order status to 'shipped' for all 'pending' orders older than 3 days
6. Delete all order_items for cancelled orders
7. Update customer emails to lowercase
8. Set publication_year to NULL for books where it's 0 or negative

Remember: Always SELECT first to see what will be affected!
*/