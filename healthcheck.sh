#!/bin/bash
set -e

CONTAINER_NAME="demo-app"
HEALTH_ENDPOINT="http://localhost:5000/health"
MAX_RETRIES=10
RETRY_DELAY=2

echo "Checking $CONTAINER_NAME..."

if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "ERROR: Container $CONTAINER_NAME is not running"
    exit 1
fi

echo "Container is running"

for i in $(seq 1 $MAX_RETRIES); do
    if curl -f -s "$HEALTH_ENDPOINT" > /dev/null 2>&1; then
        echo "App is responding"
        break
    fi
    
    if [ $i -eq $MAX_RETRIES ]; then
        echo "ERROR: App not ready after $((MAX_RETRIES * RETRY_DELAY)) seconds"
        exit 1
    fi
    
    echo "  Attempt $i/$MAX_RETRIES: waiting..."
    sleep $RETRY_DELAY
done

HEALTH_RESPONSE=$(curl -s "$HEALTH_ENDPOINT")

if [ -z "$HEALTH_RESPONSE" ]; then
    echo "ERROR: Health endpoint returned empty"
    exit 1
fi

if echo "$HEALTH_RESPONSE" | grep -q '"status".*"healthy"'; then
    echo "Health endpoint OK: $HEALTH_RESPONSE"
else
    echo "ERROR: Health check failed"
    echo "Response: $HEALTH_RESPONSE"
    exit 1
fi

ROOT_RESPONSE=$(curl -s "http://localhost:5000/")

if echo "$ROOT_RESPONSE" | grep -q "Hello World"; then
    echo "Root endpoint OK"
else
    echo "ERROR: Root endpoint failed"
    exit 1
fi

echo "All checks passed!"
exit 0

