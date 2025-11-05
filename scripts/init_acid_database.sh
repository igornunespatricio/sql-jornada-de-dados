#!/bin/sh

set -e

# Database configuration
DATABASE_NAME="northwind"
DB_USER="admin"
DB_HOST="postgres"
DB_PASSWORD="admin"
NEW_DB="acid"

echo "Starting $NEW_DB database initialization..."

# Install PostgreSQL client if not present
if ! command -v psql &> /dev/null; then
    echo "Installing PostgreSQL client..."
    apk add --no-cache postgresql-client
fi

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DATABASE_NAME -c '\q' 2>/dev/null; do
    echo "PostgreSQL is unavailable - sleeping"
    sleep 2
done

echo "PostgreSQL is ready!"

# Create $NEW_DB database
echo "Creating $NEW_DB database..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DATABASE_NAME -c "CREATE DATABASE $NEW_DB;" 2>/dev/null || echo "Database $NEW_DB might already exist"

# Initialize $NEW_DB database with tables and data
echo "Initializing $NEW_DB database with tables and data..."
if [ -f "/scripts/$NEW_DB.sql" ]; then
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $NEW_DB -f "/scripts/$NEW_DB.sql"
    echo "$NEW_DB database initialized successfully!"
else
    echo "Error: /scripts/$NEW_DB.sql file not found!"
    exit 1
fi

echo "$NEW_DB database initialization completed!"