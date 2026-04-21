#!/bin/bash
echo "--- Running Smoke Tests ---"

# Test 1: Web Server Response
curl -s --head URL="http://localhost:8081/index.html" | head -n 1 | grep "200" > /dev/null
WEB_RES=$?

# Test 2: PHP/DB Connectivity (via the info.php page)
curl -s http://localhost:8081/info.php | grep "Connected to Database" > /dev/null
DB_RES=$?

if [ $WEB_RES -eq 0 ] && [ $DB_RES -eq 0 ]; then
    echo "✅ SMOKE TEST PASSED: Web and DB are fully operational."
    exit 0
else
    echo "❌ SMOKE TEST FAILED: Verify container connections."
    exit 1
fi