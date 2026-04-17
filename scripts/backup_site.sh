#!/bin/bash
BACKUP_DIR="./backups/site"
mkdir -p $BACKUP_DIR
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
# Change db-app to ticket-db
DB_POD=$(kubectl get pod -l app=ticket-db -n ticket-app-ns -o jsonpath='{.items[0].metadata.name}')
echo "--- Starting Site Backup ---"
tar -czf $BACKUP_DIR/site_backup_$TIMESTAMP.tar.gz ./app

if [ $? -eq 0 ]; then
    echo "✅ Site backup completed: $BACKUP_DIR/site_backup_$TIMESTAMP.tar.gz"
else
    echo "❌ Error: Site backup failed."
    exit 1
fi