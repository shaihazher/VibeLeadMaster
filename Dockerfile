# ---------- Stage 1: obtain Reacher binary ----------
FROM reacherhq/backend:latest AS reacher

# ---------- Stage 2: final image ----------
FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1
ENV PORT=10000

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Copy Reacher binary from the first stage into the final image
COPY --from=reacher /reacher_backend /usr/local/bin/reacher_backend

# Ensure entrypoint is executable
RUN chmod +x /entrypoint.sh

EXPOSE 10000

ENTRYPOINT ["/entrypoint.sh"]
