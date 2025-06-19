FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1
ENV PORT=10000

WORKDIR /app

# Install curl for binary download and dependencies for Python packages
RUN apt-get update && apt-get install -y curl gcc libffi-dev libpq-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your app source code
COPY . .

# Download Reacher CLI binary directly from GitHub
RUN curl -L https://github.com/reacherhq/backend/releases/download/v0.10.1/reacher_backend-linux-x86_64 \
    -o /usr/local/bin/reacher_backend && \
    chmod +x /usr/local/bin/reacher_backend

# Make sure your entrypoint is executable
RUN chmod +x /entrypoint.sh

EXPOSE 10000
ENTRYPOINT ["/entrypoint.sh"]
