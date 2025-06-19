#!/usr/bin/env bash
set -e

# Wait a moment to ensure Reacher has started
sleep 2



# 2️⃣ Start FastAPI (foreground so container stays alive)
uvicorn main:app --host 0.0.0.0 --port ${PORT:-10000}
