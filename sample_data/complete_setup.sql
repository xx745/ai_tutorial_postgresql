-- complete_setup.sql
-- Run this file to set up the complete tutorial database

-- Create the database (run this separately in psql)
-- CREATE DATABASE tutorial_db;
-- \c tutorial_db

-- =============================================
-- CREATE ALL TABLES
-- =============================================

-- Authors table
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_year INTEGER,
    nationality VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Books table  
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publication_year INTEGER,
    genre VARCHAR(50),
    price DECIMAL(8,2),
    pages INTEGER,
    isbn VARCHAR(13) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    registration_date DATE DEFAULT CURRENT_DATE
);

-- Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date TIMESTAMP DEFAULT NOW(),
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending'
);

-- Order items table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    book_id INTEGER REFERENCES books(book_id),
    quantity INTEGER NOT NULL DEFAULT 1,
    price_per_item DECIMAL(8,2)
);

-- =============================================
-- INSERT SAMPLE DATA
-- =============================================

-- Authors
INSERT INTO authors (first_name, last_name, birth_year, nationality) VALUES
    ('Jane', 'Austen', 1775, 'British'),
    ('George', 'Orwell', 1903, 'British'),
    ('Harper', 'Lee', 1926, 'American'),
    ('Gabriel', 'García Márquez', 1927, 'Colombian'),
    ('Toni', 'Morrison', 1931, 'American'),
    ('J.K.', 'Rowling', 1965, 'British'),
    ('Mark', 'Twain', 1835, 'American'),
    ('Charles', 'Dickens', 1812, 'British'),
    ('Virginia', 'Woolf', 1882, 'British'),
    ('Leo', 'Tolstoy', 1828, 'Russian');

-- Books
INSERT INTO books (title, author_id, publication_year, genre, price, pages, isbn) VALUES
    ('Pride and Prejudice', 1, 1813, 'Romance', 12.99, 432, '9780141439518'),
    ('1984', 2, 1949, 'Dystopian Fiction', 13.99, 328, '9780451524935'),
    ('Animal Farm', 2, 1945, 'Political Satire', 10.99, 112, '9780451526342'),
    ('To Kill a Mockingbird', 3, 1960, 'Literary Fiction', 14.99, 376, '9780061120084'),
    ('One Hundred Years of Solitude', 4, 1967, 'Magical Realism', 16.99, 417, '9780060883287'),
    ('Beloved', 5, 1987, 'Literary Fiction', 15.99, 324, '9781400033416'),
    ('Harry Potter and the Philosopher''s Stone', 6, 1997, 'Fantasy', 8.99, 223, '9780747532699'),
    ('The Adventures of Huckleberry Finn', 7, 1884, 'Adventure', 11.99, 366, '9780486280615'),
    ('Great Expectations', 8, 1861, 'Literary Fiction', 13.49, 505, '9780141439563'),
    ('Mrs. Dalloway', 9, 1925, 'Modernist Fiction', 12.49, 194, '9780156628709'),
    ('War and Peace', 10, 1869, 'Historical Fiction', 19.99, 1225, '9780307266934');

-- Customers
INSERT INTO customers (first_name, last_name, email, phone, address) VALUES
    ('John', 'Smith', 'john.smith@email.com', '555-0101', '123 Main St, Anytown, USA'),
    ('Emily', 'Johnson', 'emily.j@email.com', '555-0102', '456 Oak Ave, Springfield, USA'),
    ('Michael', 'Brown', 'mbrown@email.com', '555-0103', '789 Pine Rd, Somewhere, USA'),
    ('Sarah', 'Davis', 'sarah.davis@email.com', '555-0104', '321 Elm St, Nowhere, USA'),
    ('David', 'Wilson', 'david.w@email.com', '555-0105', '654 Maple Dr, Anyplace, USA'),
    ('Lisa', 'Garcia', 'lisa.garcia@email.com', '555-0106', '987 Cedar Ln, Someplace, USA');

-- Orders
INSERT INTO orders (customer_id, total_amount, status, order_date) VALUES
    (1, 26.98, 'completed', '2023-10-01 10:30:00'),
    (2, 14.99, 'completed', '2023-10-02 15:45:00'), 
    (3, 40.97, 'pending', '2023-10-03 09:15:00'),
    (1, 13.99, 'shipped', '2023-10-04 14:20:00'),
    (4, 28.98, 'completed', '2023-10-05 11:00:00'),
    (5, 8.99, 'completed', '2023-10-06 16:30:00'),
    (2, 32.48, 'pending', '2023-10-07 12:45:00');

-- Order Items
INSERT INTO order_items (order_id, book_id, quantity, price_per_item) VALUES
    -- Order 1: John Smith
    (1, 1, 1, 12.99),  -- Pride and Prejudice
    (1, 2, 1, 13.99),  -- 1984
    
    -- Order 2: Emily Johnson  
    (2, 4, 1, 14.99),  -- To Kill a Mockingbird
    
    -- Order 3: Michael Brown
    (3, 2, 1, 13.99),  -- 1984
    (3, 3, 1, 10.99),  -- Animal Farm
    (3, 5, 1, 16.99),  -- One Hundred Years of Solitude
    
    -- Order 4: John Smith again
    (4, 2, 1, 13.99),  -- 1984
    
    -- Order 5: Sarah Davis
    (5, 1, 1, 12.99),  -- Pride and Prejudice
    (5, 6, 1, 15.99),  -- Beloved
    
    -- Order 6: David Wilson
    (6, 7, 1, 8.99),   -- Harry Potter
    
    -- Order 7: Emily Johnson
    (7, 9, 1, 13.49),  -- Great Expectations
    (7, 10, 1, 12.49), -- Mrs. Dalloway
    (7, 8, 1, 11.99);  -- Huckleberry Finn

-- =============================================
-- CREATE INDEXES FOR PERFORMANCE
-- =============================================

CREATE INDEX idx_books_author_id ON books(author_id);
CREATE INDEX idx_books_genre ON books(genre);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_book_id ON order_items(book_id);

-- =============================================
-- VERIFY SETUP
-- =============================================

-- Check all tables have data
SELECT 'Authors' AS table_name, COUNT(*) AS record_count FROM authors
UNION ALL
SELECT 'Books', COUNT(*) FROM books
UNION ALL  
SELECT 'Customers', COUNT(*) FROM customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM order_items;

-- Show table relationships
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
WHERE tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name;

-- Database setup complete message
SELECT 'Database setup complete! You can now run the tutorial exercises.' AS setup_status;

-- Quick test query
SELECT 
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    b.price
FROM books b
JOIN authors a ON b.author_id = a.author_id
ORDER BY b.title
LIMIT 5;
