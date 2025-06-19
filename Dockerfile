# ---------- Stage 1: grab the binary ----------
FROM reacherhq/backend:v0.10.1 AS reacher

# ---------- Stage 2: your Python service -----
FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1
ENV PORT=10000
WORKDIR /app

# Python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# App source
COPY . .

# Reacher CLI
COPY --from=reacher /reacher_backend /usr/local/bin/reacher_backend
RUN chmod +x /usr/local/bin/reacher_backend /entrypoint.sh

EXPOSE 10000
ENTRYPOINT ["/entrypoint.sh"]
