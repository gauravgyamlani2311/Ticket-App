#!/bin/bash
# Update the URL to port 30007 and point to the correct file
URL="http://192.168.49.2:30007"info.php
echo "--- Checking Application Health ---"

STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$STATUS" -eq 200 ]; then
    echo "✅ Health Check Passed: Status 200 (OK)"
    exit 0
else
    echo "❌ Health Check Failed: Status $STATUS. Check 'make logs' for details."
    exit 1
fi
