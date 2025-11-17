#!/bin/bash

# Generate a clean config.json without any comments
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
    "db_name": "sqlite3",
    "db_path": "gophish.db",
    "migrations_prefix": "db/db_",
    "contact_address": "",
    "logging": {
        "filename": ""
    }
}
EOF

# Use jq to safely update config values from environment variables
if [[ ! -z "${GOPHISH_ADMIN_LISTEN_URL}" ]]; then
    jq --arg url "${GOPHISH_ADMIN_LISTEN_URL}" '.admin_server.listen_url = $url' config.json > config.tmp && mv config.tmp config.json
fi

if [[ ! -z "${GOPHISH_ADMIN_USE_TLS}" ]]; then
    jq --argjson use_tls "${GOPHISH_ADMIN_USE_TLS}" '.admin_server.use_tls = $use_tls' config.json > config.tmp && mv config.tmp config.json
fi

if [[ ! -z "${GOPHISH_PHISH_LISTEN_URL}" ]]; then
    jq --arg url "${GOPHISH_PHISH_LISTEN_URL}" '.phish_server.listen_url = $url' config.json > config.tmp && mv config.tmp config.json
fi

if [[ ! -z "${GOPHISH_PHISH_USE_TLS}" ]]; then
    jq --argjson use_tls "${GOPHISH_PHISH_USE_TLS}" '.phish_server.use_tls = $use_tls' config.json > config.tmp && mv config.tmp config.json
fi

echo "Generated config.json:"
cat config.json

# Run GoPhish
./gophish
