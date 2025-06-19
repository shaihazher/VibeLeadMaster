#!/usr/bin/env bash
set -e

# 1️⃣ Start Reacher in the background
export RCH_HTTP_HOST=0.0.0.0
export RCH_PORT=8080
reacher_backend --port $RCH_PORT &

# Wait a moment to ensure Reacher has started
sleep 2

# Optional: check if Reacher is up
echo "Checking Reacher health..."
curl -s --fail http://127.0.0.1:8080/health || {
  echo "❌ Reacher did not respond on port 8080"
  exit 1
}

# Start FastAPI
echo "Starting FastAPI..."

# 2️⃣ Start FastAPI (foreground so container stays alive)
uvicorn main:app --host 0.0.0.0 --port ${PORT:-10000}
