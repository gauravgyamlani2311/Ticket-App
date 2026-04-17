#!/bin/bash
echo "--- Starting Database Backup ---"

# This command finds the DB pod name automatically using labels
DB_POD=$(kubectl get pod -n ticket-app-ns -l app=ticket-db -o jsonpath="{.items[0].metadata.name}")

if [ -z "$DB_POD" ]; then
    echo "❌ Error: Database pod not found. Is the container running?"
    exit 1
fi
mkdir -p ./backups/db
# Run the backup
kubectl exec $DB_POD -n ticket-app-ns -- mysqldump -u root -ppassword ticket_db > ./backups/db/db_backup_$(date +%Y%m%d_%H%M%S).sql

if [ $? -eq 0 ]; then
    echo "✅ Database backup completed successfully."
else
    echo "❌ Error: Database backup failed."
    exit 1
fi
