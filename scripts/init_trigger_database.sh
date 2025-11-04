#!/bin/sh

set -e

# Database configuration
DATABASE_NAME="northwind"
DB_USER="admin"
DB_HOST="postgres"
DB_PASSWORD="admin"

echo "Starting trigger database initialization..."

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

# Create trigger database
echo "Creating trigger database..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DATABASE_NAME -c "CREATE DATABASE trigger;" 2>/dev/null || echo "Database trigger might already exist"

# Initialize trigger database with tables and data
echo "Initializing trigger database with tables and data..."
if [ -f "/scripts/trigger.sql" ]; then
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d trigger -f /scripts/trigger.sql
    echo "trigger database initialized successfully!"
else
    echo "Error: /scripts/trigger.sql file not found!"
    exit 1
fi

echo "trigger database initialization completed!"