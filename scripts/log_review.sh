#!/bin/bash
echo "--- Reviewing Recent Error Logs ---"

# Search for common error keywords in the last 50 lines
docker-compose logs --tail=50 | grep -Ei "error|critical|failed|fatal"

if [ $? -ne 0 ]; then
    echo "✅ No critical errors found in recent logs."
else
    echo "⚠️  Errors detected above. Please investigate."
fi