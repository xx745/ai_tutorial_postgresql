-- 03_insert_data.sql  
-- Adding Data to Your Tables

-- =============================================
-- LESSON 3: INSERTING DATA
-- =============================================

/*
INSERT statement adds new rows to a table
Basic syntax: INSERT INTO table_name (columns) VALUES (values);
*/

-- =============================================
-- BASIC INSERT EXAMPLES
-- =============================================

-- Insert a single author
INSERT INTO authors (first_name, last_name, birth_year, nationality) 
VALUES ('Jane', 'Austen', 1775, 'British');

-- Insert multiple authors at once
INSERT INTO authors (first_name, last_name, birth_year, nationality) VALUES
    ('George', 'Orwell', 1903, 'British'),
    ('Harper', 'Lee', 1926, 'American'),
    ('Gabriel', 'García Márquez', 1927, 'Colombian'),
    ('Toni', 'Morrison', 1931, 'American'),
    ('J.K.', 'Rowling', 1965, 'British');

-- When you don't specify all columns, others get default values
INSERT INTO authors (first_name, last_name) 
VALUES ('Anonymous', 'Writer');

-- =============================================
-- INSERTING BOOKS
-- =============================================

-- First, let's see what author_id values we have
SELECT author_id, first_name, last_name FROM authors;

-- Insert books (using the author_id from above results)
INSERT INTO books (title, author_id, publication_year, genre, price, pages, isbn) VALUES
    ('Pride and Prejudice', 1, 1813, 'Romance', 12.99, 432, '9780141439518'),
    ('1984', 2, 1949, 'Dystopian Fiction', 13.99, 328, '9780451524935'),
    ('Animal Farm', 2, 1945, 'Political Satire', 10.99, 112, '9780451526342'),
    ('To Kill a Mockingbird', 3, 1960, 'Literary Fiction', 14.99, 376, '9780061120084'),
    ('One Hundred Years of Solitude', 4, 1967, 'Magical Realism', 16.99, 417, '9780060883287');

-- =============================================
-- INSERTING CUSTOMERS
-- =============================================

INSERT INTO customers (first_name, last_name, email, phone, address) VALUES
    ('John', 'Smith', 'john.smith@email.com', '555-0101', '123 Main St, Anytown, USA'),
    ('Emily', 'Johnson', 'emily.j@email.com', '555-0102', '456 Oak Ave, Springfield, USA'),
    ('Michael', 'Brown', 'mbrown@email.com', '555-0103', '789 Pine Rd, Somewhere, USA'),
    ('Sarah', 'Davis', 'sarah.davis@email.com', '555-0104', '321 Elm St, Nowhere, USA');

-- =============================================
-- CREATING ORDERS
-- =============================================

-- Insert some orders
INSERT INTO orders (customer_id, total_amount, status) VALUES
    (1, 26.98, 'completed'),
    (2, 14.99, 'completed'), 
    (3, 40.97, 'pending'),
    (1, 13.99, 'shipped');

-- =============================================
-- INSERTING ORDER ITEMS
-- =============================================

-- Order 1: John Smith bought 2 books
INSERT INTO order_items (order_id, book_id, quantity, price_per_item) VALUES
    (1, 1, 1, 12.99),  -- Pride and Prejudice
    (1, 2, 1, 13.99);  -- 1984

-- Order 2: Emily Johnson bought 1 book  
INSERT INTO order_items (order_id, book_id, quantity, price_per_item) VALUES
    (2, 4, 1, 14.99);  -- To Kill a Mockingbird

-- Order 3: Michael Brown bought 3 books
INSERT INTO order_items (order_id, book_id, quantity, price_per_item) VALUES
    (3, 2, 1, 13.99),  -- 1984
    (3, 3, 1, 10.99),  -- Animal Farm  
    (3, 5, 1, 16.99);  -- One Hundred Years of Solitude

-- Order 4: John Smith bought another book
INSERT INTO order_items (order_id, book_id, quantity, price_per_item) VALUES
    (4, 2, 1, 13.99);  -- 1984

-- =============================================
-- INSERT VARIATIONS
-- =============================================

-- You can insert without specifying column names (but not recommended)
-- This inserts values in the exact order columns were defined
INSERT INTO authors VALUES (DEFAULT, 'Mark', 'Twain', 1835, 'American');

-- Insert with DEFAULT keyword for columns with default values
INSERT INTO customers (first_name, last_name, email, registration_date) 
VALUES ('Alice', 'Wilson', 'alice@email.com', DEFAULT);

-- Insert and return the generated ID
INSERT INTO authors (first_name, last_name, nationality) 
VALUES ('Charles', 'Dickens', 'British') 
RETURNING author_id;

-- =============================================
-- HANDLING ERRORS
-- =============================================

-- This will fail because of duplicate email (UNIQUE constraint)
-- INSERT INTO customers (first_name, last_name, email) 
-- VALUES ('Jane', 'Doe', 'john.smith@email.com');

-- This will fail because of foreign key constraint  
-- INSERT INTO books (title, author_id) VALUES ('Some Book', 999);

-- This will fail because of CHECK constraint
-- INSERT INTO people (first_name, last_name, age) VALUES ('Test', 'Person', -5);

-- =============================================
-- USEFUL INSERT TECHNIQUES
-- =============================================

-- Insert data from another table (we'll learn SELECT first, but here's a preview)
-- INSERT INTO backup_authors SELECT * FROM authors WHERE nationality = 'British';

-- Insert with calculation
INSERT INTO books (title, author_id, publication_year, genre, price, pages) 
VALUES ('New Book', 1, EXTRACT(YEAR FROM NOW()), 'Fiction', 15.99, 300);

-- Conditional insert (only if data doesn't exist) - STEP BY STEP:
-- Step 1: Use INSERT INTO with SELECT instead of VALUES
-- Step 2: SELECT provides the values to insert ('Virginia', 'Woolf', 'British')
-- Step 3: WHERE NOT EXISTS checks if a condition is false
-- Step 4: The subquery SELECT 1 FROM authors WHERE... looks for existing records
-- Step 5: If NO matching record is found, NOT EXISTS becomes true and INSERT happens
-- Step 6: If a matching record IS found, NOT EXISTS becomes false and INSERT is skipped
-- This prevents duplicate entries and avoids constraint violation errors
INSERT INTO authors (first_name, last_name, nationality)
SELECT 'Virginia', 'Woolf', 'British'
WHERE NOT EXISTS (
    SELECT 1 FROM authors 
    WHERE first_name = 'Virginia' AND last_name = 'Woolf'
);

-- =============================================
-- KEY CONCEPTS LEARNED
-- =============================================

/*
1. INSERT INTO table (columns) VALUES (values)
2. Insert single row vs multiple rows  
3. DEFAULT keyword for default values
4. RETURNING clause to get generated IDs
5. Foreign key relationships when inserting
6. Constraint violations and error handling
7. Inserting calculated values
8. Conditional inserts with NOT EXISTS
*/

-- =============================================
-- PRACTICE EXERCISES
-- =============================================

/*
Try these exercises:

1. Add a new author: 'Leo Tolstoy', born 1828, Russian
2. Add his book: 'War and Peace', published 1869, 'Historical Fiction', 1225 pages
3. Create a new customer with your own information  
4. Create an order for that customer buying War and Peace
5. Add the order item for that purchase

Remember: Use SELECT to find the IDs you need for foreign keys!
*/