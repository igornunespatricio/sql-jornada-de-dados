#!/bin/sh
set -e

# Install dependencies if not already installed
if ! command -v psql >/dev/null 2>&1; then
    echo "Installing PostgreSQL client..."
    apk add --no-cache postgresql-client
fi

# Check if we're running in cron mode
if [ "$1" = "--cron" ]; then
    echo "Starting in cron mode - will run every minute"
    
    if ! command -v crond >/dev/null 2>&1; then
        echo "Installing cron..."
        apk add --no-cache cronie
    fi
    
    # Set up cron job
    echo "* * * * * /scripts/init_northwind_views.sh --run-once" > /var/spool/cron/crontabs/root
    chmod 600 /var/spool/cron/crontabs/root
    
    echo "Starting cron daemon..."
    crond -f -l 2
    exit 0
fi

# Database configuration
DATABASE_NAME="northwind"
DB_USER="admin"
DB_HOST="postgres"
DB_PASSWORD="admin"

# Set password environment variable
export PGPASSWORD="$DB_PASSWORD"

# Wait for PostgreSQL to be ready
until pg_isready -h $DB_HOST -U $DB_USER -d $DATABASE_NAME; do
  echo "Waiting for PostgreSQL database '$DATABASE_NAME'..."
  sleep 2
done

# Execute all view files
echo "Creating views in database '$DATABASE_NAME'..."
for file in /views/*.sql; do
  if [ -f "$file" ]; then
    echo "Executing: $(basename $file)"
    psql -h $DB_HOST -U $DB_USER -d $DATABASE_NAME -f "$file"
  fi
done

echo "All views created successfully in database '$DATABASE_NAME'"

# If this was a single run from cron, exit
if [ "$1" = "--run-once" ]; then
    exit 0
fi