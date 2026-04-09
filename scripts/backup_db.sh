#!/bin/bash
BACKUP_DIR="./backups/db"
mkdir -p $BACKUP_DIR
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "--- Starting Database Backup ---"
# Note: 'db' is the service name from your docker-compose
docker-compose exec -T db mysqldump -u root -ppassword ticket_db > $BACKUP_DIR/db_backup_$TIMESTAMP.sql

if [ $? -eq 0 ]; then
    echo "✅ Database backup completed: $BACKUP_DIR/db_backup_$TIMESTAMP.sql"
else
    echo "❌ Error: Database backup failed. Is the container running?"
    exit 1
fi