-- 01_setup.sql
-- PostgreSQL Setup and Basic Concepts

-- =============================================
-- LESSON 1: DATABASE BASICS
-- =============================================

/*
What is a Database?
- A database is like a digital filing cabinet
- It stores information in tables (like spreadsheets)
- Each table has rows (records) and columns (fields)

What is PostgreSQL?
- A powerful, open-source relational database
- Uses SQL (Structured Query Language)
- Great for both simple and complex applications
*/

-- =============================================
-- CONNECTING TO POSTGRESQL
-- =============================================

/*
To connect to PostgreSQL, you typically use:

Command line:
psql -h localhost -U username -d database_name

Common GUI tools:
- pgAdmin (official)
- DBeaver (free)
- DataGrip (JetBrains)
*/

-- =============================================
-- CREATING YOUR FIRST DATABASE
-- =============================================

-- Create a new database for our tutorial
CREATE DATABASE tutorial_db;

-- Connect to the database (in psql, use: \c tutorial_db)

-- Check what databases exist
-- \l (in psql command line)

-- =============================================
-- BASIC SQL CONCEPTS
-- =============================================

/*
SQL Commands are divided into categories:

1. DDL (Data Definition Language)
   - CREATE, ALTER, DROP
   - Used to create/modify database structure

2. DML (Data Manipulation Language)  
   - SELECT, INSERT, UPDATE, DELETE
   - Used to work with data

3. DCL (Data Control Language)
   - GRANT, REVOKE
   - Used to control access permissions
*/

-- =============================================
-- POSTGRESQL SPECIFIC FEATURES
-- =============================================

-- Check PostgreSQL version
SELECT version();

-- Show current database
SELECT current_database();

-- Show current user
SELECT current_user;

-- Show current date and time
SELECT NOW();

-- PostgreSQL has many built-in data types:
-- INTEGER, VARCHAR, TEXT, DATE, TIMESTAMP, BOOLEAN, JSON, etc.

-- =============================================
-- HELPFUL PSQL COMMANDS (for command line)
-- =============================================

/*
\l          - List all databases
\c dbname   - Connect to database
\dt         - List all tables
\d table    - Describe table structure  
\q          - Quit psql
\h          - Help with SQL commands
\?          - Help with psql commands
*/