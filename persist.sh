#!/bin/bash
# Backup location that might persist better
BACKUP_DB="/tmp/gophish_backup.db"
CURRENT_DB="/tmp/gophish.db"

# If backup exists, restore it
if [ -f "$BACKUP_DB" ]; then
    echo "Restoring database from backup..."
    cp "$BACKUP_DB" "$CURRENT_DB"
fi

# Start GoPhish
./gophish &

# Wait a bit, then backup the database
sleep 30
cp "$CURRENT_DB" "$BACKUP_DB"
echo "Database backed up"
