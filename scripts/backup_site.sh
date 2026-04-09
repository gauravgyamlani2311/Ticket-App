#!/bin/bash
BACKUP_DIR="./backups/site"
mkdir -p $BACKUP_DIR
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "--- Starting Site Backup ---"
tar -czf $BACKUP_DIR/site_backup_$TIMESTAMP.tar.gz ./app

if [ $? -eq 0 ]; then
    echo "✅ Site backup completed: $BACKUP_DIR/site_backup_$TIMESTAMP.tar.gz"
else
    echo "❌ Error: Site backup failed."
    exit 1
fi