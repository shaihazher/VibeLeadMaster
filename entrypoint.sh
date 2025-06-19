#!/usr/bin/env bash
set -e

# 1️⃣ Start Reacher in the background
export RCH_HTTP_HOST=0.0.0.0
export RCH_PORT=8080
reacher_backend --port $RCH_PORT &

# Wait a moment to ensure Reacher has started
sleep 2

# 2️⃣ Start FastAPI (foreground so container stays alive)
uvicorn main:app --host 0.0.0.0 --port ${PORT:-10000}
