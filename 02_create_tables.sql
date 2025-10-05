-- 02_create_tables.sql
-- Creating Tables and Understanding Data Types

-- =============================================
-- LESSON 2: CREATING YOUR FIRST TABLE
-- =============================================

/*
A table is like a spreadsheet with:
- Columns (fields) that define what type of data we store
- Rows (records) that contain actual data
- Each column has a data type (INTEGER, VARCHAR, DATE, etc.)
*/

-- Let's create a simple table for storing information about people
CREATE TABLE people (
    id INTEGER,
    first_name VARCHAR(50),
    last_name VARCHAR(50), 
    age INTEGER,
    email VARCHAR(100)
);

-- Look at the table structure
-- In psql: \d people

-- =============================================
-- BETTER TABLE DESIGN WITH CONSTRAINTS
-- =============================================

-- Let's drop the table and create a better version
DROP TABLE people;

CREATE TABLE people (
    id SERIAL PRIMARY KEY,           -- SERIAL auto-generates numbers
    first_name VARCHAR(50) NOT NULL, -- NOT NULL means required
    last_name VARCHAR(50) NOT NULL,
    age INTEGER CHECK (age >= 0 AND age <= 150), -- CHECK constraint
    email VARCHAR(100) UNIQUE,       -- UNIQUE means no duplicates
    created_at TIMESTAMP DEFAULT NOW() -- DEFAULT sets automatic value
);

-- =============================================
-- COMMON POSTGRESQL DATA TYPES
-- =============================================

CREATE TABLE data_types_demo (
    -- Numbers
    small_number SMALLINT,        -- -32,768 to 32,767
    regular_number INTEGER,       -- -2 billion to 2 billion  
    big_number BIGINT,           -- Very large numbers
    decimal_number DECIMAL(10,2), -- 10 digits total, 2 after decimal
    float_number REAL,           -- Floating point
    
    -- Text
    short_text VARCHAR(50),      -- Variable length, max 50 chars
    long_text TEXT,             -- Unlimited length text
    fixed_text CHAR(5),         -- Fixed length, exactly 5 chars
    
    -- Date and Time  
    just_date DATE,             -- 2023-12-25
    just_time TIME,             -- 14:30:00
    date_and_time TIMESTAMP,    -- 2023-12-25 14:30:00
    
    -- Boolean
    is_active BOOLEAN,          -- TRUE or FALSE
    
    -- Other useful types
    json_data JSON,             -- Store JSON documents
    uuid_field UUID             -- Universally unique identifier
);

-- =============================================
-- CREATING A PRACTICAL EXAMPLE: BOOKSTORE
-- =============================================

-- Let's create tables for a simple bookstore system

-- Authors table
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_year INTEGER,
    nationality VARCHAR(50)
);

-- Books table  
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INTEGER REFERENCES authors(author_id), -- Foreign key
    publication_year INTEGER,
    genre VARCHAR(50),
    price DECIMAL(8,2),
    pages INTEGER,
    isbn VARCHAR(13) UNIQUE
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

-- Order items table (many-to-many relationship between orders and books)
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    book_id INTEGER REFERENCES books(book_id),
    quantity INTEGER NOT NULL DEFAULT 1,
    price_per_item DECIMAL(8,2)
);

-- =============================================
-- VIEWING YOUR TABLES
-- =============================================

-- List all tables in current database
-- In psql: \dt

-- See detailed info about a specific table  
-- In psql: \d books

-- You can also use SQL to get table information:
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- =============================================
-- KEY CONCEPTS LEARNED
-- =============================================

/*
1. CREATE TABLE - Creates new table
2. Data Types - INTEGER, VARCHAR, TEXT, DATE, etc.
3. Constraints:
   - PRIMARY KEY - Uniquely identifies each row
   - NOT NULL - Field cannot be empty
   - UNIQUE - No duplicate values allowed
   - CHECK - Custom validation rules  
   - REFERENCES - Foreign key (links to another table)
   - DEFAULT - Automatic default value
4. SERIAL - Auto-incrementing number
5. DROP TABLE - Deletes a table
*/