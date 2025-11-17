#!/bin/bash

set -e  # Exit on any error

# Generate base config
cat > config.json << 'EOF'
{
    "admin_server": {
        "listen_url": "0.0.0.0:3333",
        "use_tls": false
    },
    "phish_server": {
        "listen_url": "0.0.0.0:8080",
        "use_tls": false
    },
    "db_name": "postgres",
    "db_path": "placeholder",
    "migrations_prefix": "db/db_",
    "contact_address": "",
    "logging": {
        "filename": ""
    }
}
EOF

# Update database connection string from environment variables
if [[ ! -z "${DATABASE_URL}" ]]; then
    echo "Using DATABASE_URL for connection"
    jq --arg db_path "${DATABASE_URL}" '.db_path = $db_path' config.json > config.tmp && mv config.tmp config.json
elif [[ ! -z "${DB_HOST}" ]]; then
    echo "Using individual DB environment variables"
    DB_CONNECTION="host=${DB_HOST} port=${DB_PORT} user=${DB_USER} dbname=${DB_NAME} password=${DB_PASSWORD} sslmode=require"
    jq --arg db_path "${DB_CONNECTION}" '.db_path = $db_path' config.json > config.tmp && mv config.tmp config.json
else
    echo "ERROR: No database configuration found!"
    echo "Please set either DATABASE_URL or DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD environment variables"
    exit 1
fi

echo "Final configuration:"
cat config.json

# Verify JSON is valid
if jq empty config.json; then
    echo "✓ Config JSON is valid"
else
    echo "✗ Config JSON is invalid!"
    exit 1
fi

echo "Starting GoPhish with PostgreSQL..."
./gophish
