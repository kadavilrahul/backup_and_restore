#!/bin/bash

# Set variables
DB_NAME="your_db"
DB_USER="your_user"
DB_PASS="your_password"  # Change this to a secure password
DUMP_FILE="/website_backups/postgres/products_db_20250316_144906.dump"

# Update system packages
echo "Updating system packages..."
sudo apt update -y

# Install PostgreSQL (if not installed)
echo "Installing PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib

# Start and enable PostgreSQL service
echo "Starting PostgreSQL service..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Switch to postgres user and execute commands
echo "Setting up database and user..."
sudo -u postgres psql <<EOF
-- Drop database if it exists
DROP DATABASE IF EXISTS $DB_NAME;

-- Create database
CREATE DATABASE $DB_NAME OWNER $DB_USER;

-- Drop user if it exists and recreate
DROP ROLE IF EXISTS $DB_USER;
CREATE ROLE $DB_USER WITH LOGIN CREATEDB CREATEROLE PASSWORD '$DB_PASS';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
EOF

# Restore the dump file
echo "Restoring the database from dump..."
sudo -u postgres pg_restore --clean --if-exists -d $DB_NAME "$DUMP_FILE"

# Verify database and table existence
echo "Verifying database..."
sudo -u postgres psql -d $DB_NAME -c "\dt"

echo "Database restoration completed successfully!"
