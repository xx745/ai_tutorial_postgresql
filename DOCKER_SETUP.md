# Docker Setup for PostgreSQL Tutorial

## Prerequisites

1. **Install Docker** and **Docker Compose** on your system:
   - **Ubuntu/Debian**: `sudo apt install docker.io docker-compose`
   - **macOS**: Install Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop)
   - **Windows**: Install Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop)

2. **Make sure Docker is running**:
   ```bash
   docker --version
   docker-compose --version
   ```

## Quick Start with Docker

### Step 1: Start the PostgreSQL Container

From the `/home/pp/prv/psql` directory, run:

```bash
# Start PostgreSQL and pgAdmin containers
docker compose up -d

# Check if containers are running
docker compose ps
```

This will:
- ✅ Start PostgreSQL 15 container on port 5432
- ✅ Start pgAdmin web interface on port 8080
- ✅ Automatically create the `tutorial_db` database
- ✅ Load sample data from `sample_data/complete_setup.sql`

### Step 2: Access Your Database

You have **3 ways** to connect to your PostgreSQL database:

#### Option A: Web Interface (Easiest)
1. Open your browser and go to: http://localhost:8080
2. Login with:
   - **Email**: `admin@tutorial.com`
   - **Password**: `admin123`
3. Add a new server with these settings:
   - **Name**: Tutorial Database
   - **Host**: `postgres` (container name)
   - **Port**: `5432`
   - **Database**: `tutorial_db`
   - **Username**: `tutorial_user`
   - **Password**: `tutorial_pass`

#### Option B: Command Line (psql in container)
```bash
# Connect directly to PostgreSQL container
docker compose exec postgres psql -U tutorial_user -d tutorial_db

# Or run psql interactively
docker compose exec postgres bash
psql -U tutorial_user -d tutorial_db
```

#### Option C: Local psql client (if you have it installed)
```bash
psql -h localhost -p 5432 -U tutorial_user -d tutorial_db
# Password: tutorial_pass
```

### Step 3: Verify Setup

Run this query to make sure everything is working:

```sql
-- Check that all tables exist with data
SELECT 'Authors' AS table_name, COUNT(*) AS record_count FROM authors
UNION ALL
SELECT 'Books', COUNT(*) FROM books
UNION ALL  
SELECT 'Customers', COUNT(*) FROM customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM order_items;
```

You should see data in all tables!

## Database Connection Details

- **Host**: `localhost` (from your machine) or `postgres` (from other containers)
- **Port**: `5432`
- **Database**: `tutorial_db`
- **Username**: `tutorial_user`
- **Password**: `tutorial_pass`

## Container Management

```bash
# Start containers
docker compose up -d

# Stop containers
docker compose down

# View logs
docker compose logs postgres
docker compose logs pgadmin

# Restart containers
docker compose restart

# Stop and remove everything (including data!)
docker compose down -v
```

## Working Through the Tutorial

Now that your database is running, you can work through the tutorial files in order:

1. `01_setup.sql` - Database basics (skip installation parts)
2. `02_create_tables.sql` - Creating tables and data types
3. `03_insert_data.sql` - Adding data to tables
4. `04_basic_queries.sql` - SELECT statements and filtering
5. `05_update_delete.sql` - Modifying and removing data
6. `06_relationships.sql` - JOINs and foreign keys
7. `07_advanced_queries.sql` - Advanced SQL techniques
8. `08_practice_exercises.sql` - Hands-on practice

### Running SQL Files

You can execute SQL files in several ways:

#### Method 1: Copy-paste into pgAdmin
1. Open pgAdmin at http://localhost:8080
2. Navigate to your database
3. Open the Query Tool
4. Copy and paste SQL from tutorial files

#### Method 2: Execute via psql in container
```bash
# Copy a file into the container and execute it
docker cp 04_basic_queries.sql psql_tutorial_db:/tmp/
docker compose exec postgres psql -U tutorial_user -d tutorial_db -f /tmp/04_basic_queries.sql
```

#### Method 3: Use psql interactively
```bash
docker compose exec postgres psql -U tutorial_user -d tutorial_db
\i /docker-entrypoint-initdb.d/complete_setup.sql
```

## Useful Docker Commands

```bash
# See running containers
docker ps

# Access container shell
docker compose exec postgres bash

# View container logs
docker compose logs -f postgres

# Backup database
docker compose exec postgres pg_dump -U tutorial_user tutorial_db > backup.sql

# Restore database
docker compose exec -T postgres psql -U tutorial_user tutorial_db < backup.sql
```

## Troubleshooting

### Container won't start?
```bash
# Check logs
docker compose logs postgres

# Make sure ports aren't in use
sudo netstat -tlnp | grep :5432
sudo netstat -tlnp | grep :8080
```

### Can't connect to database?
1. Make sure containers are running: `docker compose ps`
2. Check if PostgreSQL is ready: `docker compose exec postgres pg_isready`
3. Verify connection details match the ones above

### pgAdmin won't load?
1. Wait a minute after starting (pgAdmin takes time to initialize)
2. Try refreshing the browser
3. Check logs: `docker compose logs pgadmin`

## Data Persistence

Your data is stored in Docker volumes and will persist between container restarts. To completely remove all data:

```bash
docker compose down -v  # WARNING: This deletes all data!
```

## Advantages of This Docker Setup

✅ **Clean system** - No PostgreSQL installation on your host  
✅ **Consistent environment** - Same setup on any machine  
✅ **Easy management** - Start/stop with simple commands  
✅ **Web interface** - pgAdmin for visual database management  
✅ **Auto-setup** - Database and sample data loaded automatically  
✅ **Portable** - Share the exact same setup with others  

Ready to start learning SQL with Docker? Run `docker compose up -d` and you're good to go! 🐳🚀