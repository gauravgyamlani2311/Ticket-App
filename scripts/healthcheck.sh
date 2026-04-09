#!/bin/bash
URL="http://54.226.233.59:8081/index.html"
echo "--- Checking Application Health ---"

STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ "$STATUS" -eq 200 ]; then
    echo "✅ Health Check Passed: Status 200 (OK)"
    exit 0
else
    echo "❌ Health Check Failed: Status $STATUS. Check 'make logs' for details."
    exit 1
fi