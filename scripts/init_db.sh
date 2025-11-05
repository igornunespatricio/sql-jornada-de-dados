#!/bin/sh

set -e

# Database configuration
MASTER_DB="northwind"
DB_USER="admin"
DB_HOST="postgres"
DB_PASSWORD="admin"

# Get database name from parameter
TARGET_DB="$1"

if [ -z "$TARGET_DB" ]; then
    echo "Error: No database specified. Usage: $0 <database_name>"
    exit 1
fi

echo "Starting $TARGET_DB database initialization..."

# Install PostgreSQL client if not present
if ! command -v psql &> /dev/null; then
    echo "Installing PostgreSQL client..."
    apk add --no-cache postgresql-client
fi

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $MASTER_DB -c '\q' 2>/dev/null; do
    echo "PostgreSQL is unavailable - sleeping"
    sleep 2
done

echo "PostgreSQL is ready!"

# Create database
echo "Creating $TARGET_DB database..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $MASTER_DB -c "CREATE DATABASE $TARGET_DB;" 2>/dev/null || echo "Database $TARGET_DB might already exist"

# Initialize database with tables and data
echo "Initializing $TARGET_DB database with tables and data..."
if [ -f "/init-other-db-scripts/$TARGET_DB.sql" ]; then
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $TARGET_DB -f "/init-other-db-scripts/$TARGET_DB.sql"
    echo "$TARGET_DB database initialized successfully!"
else
    echo "Error: /init-other-db-scripts/$TARGET_DB.sql file not found!"
    exit 1
fi

echo "$TARGET_DB database initialization completed!"