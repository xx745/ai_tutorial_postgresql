# Connecting pgAdmin to PostgreSQL in Docker Containers

This guide shows you exactly how to connect pgAdmin (running in a Docker container) to PostgreSQL (also running in a Docker container) using Docker Compose.

## Prerequisites

- Docker and Docker Compose installed
- Both containers running via `docker compose up -d`

## Step-by-Step Connection Guide

### 1. Start the Containers

```bash
cd /home/pp/prv/psql
docker compose up -d
```

Verify both containers are running:
```bash
docker compose ps
```

You should see:
- `psql_tutorial_db` (PostgreSQL) - Status: Up (healthy)
- `psql_tutorial_pgladmin` (pgAdmin) - Status: Up

### 2. Access pgAdmin Web Interface

1. Open your web browser
2. Navigate to: **http://localhost:8080**
3. You'll see the pgAdmin login page

### 3. Login to pgAdmin

Enter these credentials:
- **Email Address**: `admin@tutorial.com`
- **Password**: `admin123`
- Click **Login**

### 4. Add PostgreSQL Server Connection

#### 4.1 Create New Server
1. In the left sidebar, right-click on **"Servers"**
2. Select **Create > Server...**
3. A dialog box will open with multiple tabs

#### 4.2 General Tab
- **Name**: `Tutorial Database` (or any descriptive name)
- **Server group**: Leave as "Servers" (default)
- **Comments**: Optional - you can add "PostgreSQL tutorial database"

#### 4.3 Connection Tab ⭐ (CRITICAL SETTINGS)
Enter these **exact** values:

- **Host name/address**: `postgres` 
  - ⚠️ **Important**: Use `postgres` (the service name), NOT `localhost`
- **Port**: `5432`
- **Maintenance database**: `tutorial_db`
- **Username**: `tutorial_user`
- **Password**: `tutorial_pass`
- **Save password?**: ✅ **Check this box** (recommended)

#### 4.4 Other Tabs
- **SSL**: Leave all settings as default
- **Advanced**: Leave as default
- **Parameters**: Leave as default

### 5. Save and Connect

1. Click the **Save** button
2. pgAdmin will attempt to connect to the PostgreSQL database
3. If successful, you'll see "Tutorial Database" appear under "Servers" in the left panel

### 6. Verify Connection

Expand the server tree in the left panel:
```
Servers
└── Tutorial Database
    └── Databases
        └── tutorial_db
            └── Schemas
                └── public
                    └── Tables
                        ├── authors
                        ├── books
                        ├── customers
                        ├── orders
                        └── order_items
```

### 7. Test with a Query

1. Right-click on **tutorial_db**
2. Select **Query Tool**
3. Run this test query:

```sql
SELECT 'Connection successful!' AS status;
```

4. You should see the result: "Connection successful!"

## Connection Settings Summary

| Setting | Value | Notes |
|---------|--------|-------|
| **Host** | `postgres` | ⭐ Service name from docker-compose.yml |
| **Port** | `5432` | Default PostgreSQL port |
| **Database** | `tutorial_db` | Created automatically |
| **Username** | `tutorial_user` | Defined in docker-compose.yml |
| **Password** | `tutorial_pass` | Defined in docker-compose.yml |

## Why This Works

### Docker Networking Magic 🐳

- Both containers run on the same Docker network (created by Docker Compose)
- Containers can communicate using **service names** as hostnames
- The service name `postgres` (from docker-compose.yml) becomes the hostname
- Port 5432 is the internal container port (not the external 5432 mapping)

### What NOT to Use ❌

- ~~`localhost`~~ - This refers to the pgAdmin container itself
- ~~`127.0.0.1`~~ - Same as localhost
- ~~`psql_tutorial_db`~~ - This is the container name, use service name instead

## Troubleshooting

### Connection Refused Error
```bash
# Check if containers are running
docker compose ps

# Check PostgreSQL logs
docker compose logs postgres

# Test network connectivity
docker compose exec pgadmin ping postgres
```

### Authentication Failed
- Double-check username: `tutorial_user`
- Double-check password: `tutorial_pass`
- Verify these match the values in `docker-compose.yml`

### Cannot Resolve Hostname
- Make sure you're using `postgres` (service name) not `localhost`
- Verify containers are on the same Docker network: `docker network ls`

### Containers Not Starting
```bash
# Restart everything
docker compose down
docker compose up -d

# Check for errors
docker compose logs
```

## Next Steps

Once connected, you can:

1. **Explore the sample data** in the tables
2. **Run tutorial queries** from the lesson files
3. **Use the Query Tool** for interactive SQL practice
4. **View table structures** and relationships
5. **Start with lesson 01_setup.sql** and work through the tutorial

## Sample Query to Try

```sql
-- See all books with their authors
SELECT 
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    b.price,
    b.genre
FROM books b
JOIN authors a ON b.author_id = a.author_id
ORDER BY b.title;
```

Happy SQL learning! 🎉📚