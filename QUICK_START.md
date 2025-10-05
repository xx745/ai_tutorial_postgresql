# Quick Start Guide for PostgreSQL Tutorial

## Choose Your Setup Method

**🐳 Recommended: Docker Setup (Clean & Easy)**
- No system installation needed
- Consistent environment
- Includes web interface
- See `DOCKER_SETUP.md` for full instructions

**💻 Traditional Setup (Direct Installation)**
- Install PostgreSQL directly on your system
- See instructions below

---

## Option 1: Docker Setup (Recommended)

**Prerequisites:** Docker and Docker Compose installed on your system.

```bash
# Start PostgreSQL container with sample data
docker compose up -d

# Access via web interface: http://localhost:8080
# Login: admin@tutorial.com / admin123

# Or connect via command line:
docker compose exec postgres psql -U tutorial_user -d tutorial_db
```

See `DOCKER_SETUP.md` for complete Docker instructions.

---

## Option 2: Traditional Installation

**Prerequisites:**

1. **Install PostgreSQL** on your system:
   - **Ubuntu/Debian**: `sudo apt install postgresql postgresql-contrib`
   - **macOS**: `brew install postgresql`
   - **Windows**: Download from [postgresql.org](https://www.postgresql.org/downloads/)

2. **Start PostgreSQL service**:
   - **Linux**: `sudo systemctl start postgresql`
   - **macOS**: `brew services start postgresql`
   - **Windows**: PostgreSQL should start automatically

## Getting Started (Traditional Installation)

### Step 1: Connect to PostgreSQL

```bash
# Connect as the default postgres user
sudo -u postgres psql

# Or if you set up a user account:
psql -U your_username -d postgres
```

### Step 2: Create the Tutorial Database

```sql
-- Create database
CREATE DATABASE tutorial_db;

-- Connect to it
\c tutorial_db
```

### Step 3: Set Up the Sample Data

Run the complete setup script:

```sql
\i /home/pp/prv/psql/sample_data/complete_setup.sql
```

Or copy and paste the contents of `complete_setup.sql` into your psql session.

### Step 4: Start Learning!

Now work through the tutorial files in order:

1. `01_setup.sql` - Database basics and connections
2. `02_create_tables.sql` - Creating tables and data types
3. `03_insert_data.sql` - Adding data to tables
4. `04_basic_queries.sql` - SELECT statements and filtering
5. `05_update_delete.sql` - Modifying and removing data
6. `06_relationships.sql` - JOINs and foreign keys
7. `07_advanced_queries.sql` - Advanced SQL techniques
8. `08_practice_exercises.sql` - Hands-on practice

## Useful PostgreSQL Commands

```sql
-- List all databases
\l

-- Connect to a database
\c database_name

-- List all tables
\dt

-- Describe a table structure
\d table_name

-- Show all columns in a table
\d+ table_name

-- Get help
\h SELECT    -- Help for SELECT command
\?           -- Help for psql commands

-- Quit psql
\q
```

## Sample Queries to Try

```sql
-- See all books with authors
SELECT b.title, a.first_name || ' ' || a.last_name AS author
FROM books b
JOIN authors a ON b.author_id = a.author_id;

-- Find customers and their order totals
SELECT c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- Most popular books
SELECT b.title, COUNT(oi.order_item_id) AS times_ordered
FROM books b
LEFT JOIN order_items oi ON b.book_id = oi.book_id
GROUP BY b.book_id, b.title
ORDER BY times_ordered DESC;
```

## Tips for Learning

1. **Read the comments** - Each file has detailed explanations
2. **Try the examples** - Run each query to see the results
3. **Do the exercises** - Practice makes perfect!
4. **Experiment** - Modify the queries to see what happens
5. **Use EXPLAIN** - Add `EXPLAIN` before SELECT to see query plans

## Common Beginner Mistakes

1. **Forgetting WHERE clauses** in UPDATE/DELETE (very dangerous!)
2. **Incorrect JOIN conditions** - always match foreign keys
3. **Missing GROUP BY** when using aggregate functions
4. **Case sensitivity** - PostgreSQL is case-sensitive for identifiers in quotes
5. **Semicolons** - Don't forget them at the end of statements!

## Getting Help

- PostgreSQL official docs: https://www.postgresql.org/docs/
- SQL tutorial: https://www.w3schools.com/sql/
- Stack Overflow: https://stackoverflow.com/questions/tagged/postgresql

## What's Next?

After completing this tutorial, explore:

1. **Views and stored procedures**
2. **Triggers and functions** 
3. **Advanced indexing strategies**
4. **Performance tuning**
5. **Backup and recovery**
6. **Replication and clustering**

Good luck with your PostgreSQL journey! 🚀