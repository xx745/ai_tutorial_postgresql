-- 04_basic_queries.sql
-- Querying Data with SELECT

-- =============================================
-- LESSON 4: THE SELECT STATEMENT
-- =============================================

/*
SELECT is the most important SQL command - it retrieves data from tables
Basic syntax: SELECT columns FROM table WHERE conditions;
*/

-- =============================================
-- SIMPLE SELECT STATEMENTS
-- =============================================

-- Get all data from authors table
SELECT * FROM authors;

-- Get specific columns
SELECT first_name, last_name FROM authors;

-- Get all books
SELECT * FROM books;

-- Get book titles and prices
SELECT title, price FROM books;

-- =============================================
-- WHERE CLAUSE - FILTERING DATA
-- =============================================

-- Find books by a specific author (author_id = 2 is George Orwell)
SELECT * FROM books WHERE author_id = 2;

-- Find books with price less than $15
SELECT title, price FROM books WHERE price < 15.00;

-- Find books published after 1950
SELECT title, publication_year FROM books WHERE publication_year > 1950;

-- Find customers with specific email
SELECT * FROM customers WHERE email = 'john.smith@email.com';

-- =============================================
-- COMPARISON OPERATORS
-- =============================================

-- Equal to
SELECT * FROM books WHERE genre = 'Romance';

-- Not equal to (two ways to write it)
SELECT * FROM books WHERE genre != 'Romance';
SELECT * FROM books WHERE genre <> 'Romance';

-- Greater than, less than
SELECT * FROM books WHERE pages > 400;
SELECT * FROM books WHERE publication_year < 1900;

-- Greater than or equal, less than or equal
SELECT * FROM books WHERE price >= 15.00;
SELECT * FROM books WHERE pages <= 200;

-- =============================================
-- LOGICAL OPERATORS
-- =============================================

-- AND - both conditions must be true
SELECT * FROM books 
WHERE price > 12.00 AND pages < 400;

-- OR - either condition can be true
SELECT * FROM books 
WHERE genre = 'Romance' OR genre = 'Fiction';

-- NOT - opposite of condition
SELECT * FROM authors 
WHERE NOT nationality = 'British';

-- Complex combinations with parentheses
SELECT * FROM books 
WHERE (genre = 'Romance' OR genre = 'Fiction') 
AND price < 15.00;

-- =============================================
-- PATTERN MATCHING WITH LIKE
-- =============================================

-- Find authors whose first name starts with 'J'
SELECT * FROM authors WHERE first_name LIKE 'J%';

-- Find books with 'and' in the title (case-insensitive)
SELECT * FROM books WHERE title ILIKE '%and%';

-- Find customers with gmail addresses
SELECT * FROM customers WHERE email LIKE '%@email.com';

-- LIKE patterns:
-- %  matches any sequence of characters
-- _  matches exactly one character

-- Examples:
-- 'A%'     - starts with A
-- '%ing'   - ends with ing  
-- '%the%'  - contains the
-- 'A_e'    - A, any char, e (like "Age", "Are")

-- =============================================
-- IN OPERATOR - MULTIPLE VALUES
-- =============================================

-- Find books in specific genres
SELECT * FROM books 
WHERE genre IN ('Romance', 'Fiction', 'Dystopian Fiction');

-- Find authors from specific countries
SELECT * FROM authors 
WHERE nationality IN ('British', 'American');

-- NOT IN - exclude specific values
SELECT * FROM books 
WHERE genre NOT IN ('Romance', 'Poetry');

-- =============================================
-- RANGE QUERIES WITH BETWEEN
-- =============================================

-- Find books published between 1940 and 1970
SELECT * FROM books 
WHERE publication_year BETWEEN 1940 AND 1970;

-- Find books with price between $10 and $15
SELECT * FROM books 
WHERE price BETWEEN 10.00 AND 15.00;

-- NOT BETWEEN
SELECT * FROM books 
WHERE publication_year NOT BETWEEN 1900 AND 2000;

-- =============================================
-- NULL VALUES
-- =============================================

-- Find authors where birth_year is not specified
SELECT * FROM authors WHERE birth_year IS NULL;

-- Find authors where birth_year is specified
SELECT * FROM authors WHERE birth_year IS NOT NULL;

-- Note: Use IS NULL, not = NULL (that won't work!)

-- =============================================
-- ORDERING RESULTS
-- =============================================

-- Sort authors by last name (A to Z)
SELECT * FROM authors ORDER BY last_name;

-- Sort by last name descending (Z to A)
SELECT * FROM authors ORDER BY last_name DESC;

-- Sort books by price (lowest first)
SELECT title, price FROM books ORDER BY price;

-- Sort books by price (highest first)  
SELECT title, price FROM books ORDER BY price DESC;

-- Sort by multiple columns
SELECT * FROM books 
ORDER BY genre, price DESC;

-- Sort by column position (not recommended, but possible)
SELECT title, price FROM books ORDER BY 2 DESC; -- sorts by price

-- =============================================
-- LIMITING RESULTS
-- =============================================

-- Get only the first 3 books
SELECT * FROM books LIMIT 3;

-- Get the 3 most expensive books
SELECT title, price FROM books 
ORDER BY price DESC 
LIMIT 3;

-- Skip first 2 results, then get 3 (pagination)
SELECT * FROM books 
ORDER BY title 
LIMIT 3 OFFSET 2;

-- =============================================
-- USEFUL FUNCTIONS IN SELECT
-- =============================================

-- String functions
SELECT 
    first_name,
    last_name,
    UPPER(first_name) as first_name_upper,
    LENGTH(last_name) as last_name_length,
    CONCAT(first_name, ' ', last_name) as full_name
FROM authors;

-- Math functions  
SELECT 
    title,
    price,
    ROUND(price * 1.1, 2) as price_with_tax,
    pages,
    CEIL(pages / 100.0) as reading_time_hours
FROM books;

-- Date functions
SELECT 
    first_name,
    last_name,
    registration_date,
    AGE(registration_date) as days_since_registration,
    EXTRACT(YEAR FROM registration_date) as registration_year
FROM customers;

-- =============================================
-- DISTINCT - UNIQUE VALUES ONLY
-- =============================================

-- Get unique genres
SELECT DISTINCT genre FROM books;

-- Get unique nationalities
SELECT DISTINCT nationality FROM authors;

-- Count unique customers who made orders
SELECT COUNT(DISTINCT customer_id) FROM orders;

-- =============================================
-- ALIASES - RENAMING COLUMNS
-- =============================================

-- Use AS to give columns friendly names
SELECT 
    first_name AS "First Name",
    last_name AS "Last Name", 
    birth_year AS "Born"
FROM authors;

-- AS is optional
SELECT 
    title "Book Title",
    price "Cost ($)",
    pages "Page Count"
FROM books;

-- =============================================
-- PRACTICAL EXAMPLES
-- =============================================

-- Find all books under $15, sorted by price
SELECT title, price, genre 
FROM books 
WHERE price < 15.00 
ORDER BY price;

-- Find British authors born after 1900
SELECT first_name, last_name, birth_year 
FROM authors 
WHERE nationality = 'British' 
AND birth_year > 1900;

-- Find customers registered in the last year
SELECT first_name, last_name, registration_date
FROM customers 
WHERE registration_date >= CURRENT_DATE - INTERVAL '1 year'
ORDER BY registration_date DESC;

-- Find the 5 longest books
SELECT title, pages, author_id
FROM books 
WHERE pages IS NOT NULL
ORDER BY pages DESC 
LIMIT 5;

-- =============================================
-- KEY CONCEPTS LEARNED
-- =============================================

/*
1. SELECT * vs SELECT specific_columns
2. WHERE clause for filtering
3. Comparison operators: =, !=, <, >, <=, >=
4. Logical operators: AND, OR, NOT
5. Pattern matching: LIKE, ILIKE with % and _
6. IN operator for multiple values
7. BETWEEN for ranges
8. IS NULL / IS NOT NULL for missing data
9. ORDER BY for sorting (ASC/DESC)
10. LIMIT and OFFSET for pagination
11. DISTINCT for unique values
12. Column aliases with AS
13. Built-in functions (string, math, date)
*/

-- =============================================
-- PRACTICE EXERCISES
-- =============================================

/*
Try writing queries for these questions:

1. Find all American authors
2. Find books with more than 300 pages
3. Find books published in the 1960s (1960-1969)
4. Find authors whose names start with 'G'
5. Find the 3 cheapest books
6. Find books that are NOT 'Romance' genre
7. Find customers whose email contains 'gmail'
8. Get unique list of all book genres
9. Find books with titles containing 'the' (case-insensitive)
10. Find authors born before 1900, sorted by birth year
*/