#!/bin/sh

set -e

# Database configuration
DATABASE_NAME="northwind"
DB_USER="admin"
DB_HOST="postgres"
DB_PASSWORD="admin"

echo "Starting Itau database initialization..."

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

# Create itau database
echo "Creating itau database..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DATABASE_NAME -c "CREATE DATABASE itau;" 2>/dev/null || echo "Database itau might already exist"

# Initialize itau database with tables and data
echo "Initializing itau database with tables and data..."
if [ -f "/scripts/itau.sql" ]; then
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d itau -f /scripts/itau.sql
    echo "Itau database initialized successfully!"
else
    echo "Error: /scripts/itau.sql file not found!"
    exit 1
fi

echo "Itau database initialization completed!"