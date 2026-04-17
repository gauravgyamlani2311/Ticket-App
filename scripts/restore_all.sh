#!/bin/bash
echo "--- Starting Full Restoration ---"

# Restore DB (looks for latest .sql file)
LATEST_DB=$(ls -t ./backups/db/*.sql | head -1)
if [ -z "$LATEST_DB" ]; then
    echo "❌ No database backup found!"
else
    echo "Restoring Database from $LATEST_DB..."
    cat $LATEST_DB | docker-compose exec -T db mysql -u root -ppassword ticket_db
    echo "✅ Database restored."
fi

# Restore Site Files
LATEST_SITE=$(ls -t ./backups/site/*.tar.gz | head -1)
if [ -z "$LATEST_SITE" ]; then
    echo "❌ No site backup found!"
else
    echo "Restoring Site Files from $LATEST_SITE..."
    tar -xzf $LATEST_SITE -C .
    echo "✅ Site files restored."
fi