#!/bin/bash

set -e  # Exit on any error

# === PERSISTENT DISK SETUP ===
mkdir -p /data/gophish

# === CONFIG GENERATION ===
# Generate base config directly to persistent location
cat > /data/gophish/config.json << 'EOF'
{
    "admin_server": {
        "listen_url": "0.0.0.0:3333",
        "use_tls": false
    },
"phish_server": {
    "listen_url": "0.0.0.0:443",
    "use_tls": true,
    "cert_path": "your_domain.crt",
    "key_path": "your_domain.key"
    
    },
    "db_name": "postgres",
    "db_path": "placeholder",
    "migrations_prefix": "db/db_",
    "contact_address": "",
    "logging": {
        "filename": "/data/gophish/gophish.log"
    }
}
EOF

# === DATABASE CONFIGURATION ===
# Update database connection string from environment variables
if [[ ! -z "${DATABASE_URL}" ]]; then
    echo "Using DATABASE_URL for connection"
    jq --arg db_path "${DATABASE_URL}" '.db_path = $db_path' /data/gophish/config.json > /data/gophish/config.tmp && mv /data/gophish/config.tmp /data/gophish/config.json
elif [[ ! -z "${DB_HOST}" ]]; then
    echo "Using individual DB environment variables"
    DB_CONNECTION="host=${DB_HOST} port=${DB_PORT} user=${DB_USER} dbname=${DB_NAME} password=${DB_PASSWORD} sslmode=require"
    jq --arg db_path "${DB_CONNECTION}" '.db_path = $db_path' /data/gophish/config.json > /data/gophish/config.tmp && mv /data/gophish/config.tmp /data/gophish/config.json
else
    echo "ERROR: No database configuration found!"
    echo "Please set either DATABASE_URL or DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD environment variables"
    exit 1
fi

# === CREATE SYMLINK ===
# Link persistent config to where GoPhish expects it
ln -sf /data/gophish/config.json /app/config.json

echo "Final configuration:"
cat /data/gophish/config.json

# Verify JSON is valid
if jq empty /data/gophish/config.json; then
    echo "✓ Config JSON is valid"
else
    echo "✗ Config JSON is invalid!"
    exit 1
fi

echo "Starting GoPhish with PostgreSQL and Persistent Storage..."
./gophish
