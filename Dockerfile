FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1
ENV PORT=10000
WORKDIR /app

# Install tools for binary fetch and Python dependencies
RUN apt-get update && apt-get install -y curl gcc libffi-dev libpq-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your app and the entrypoint script
COPY . .
COPY entrypoint.sh /app/entrypoint.sh

# Fetch Reacher binary
RUN curl -L https://github.com/reacherhq/backend/releases/download/v0.10.1/reacher_backend-linux-x86_64 \
    -o /usr/local/bin/reacher_backend && chmod +x /usr/local/bin/reacher_backend

# Make the entrypoint executable
RUN chmod +x /app/entrypoint.sh

EXPOSE 10000

ENTRYPOINT ["/app/entrypoint.sh"]
