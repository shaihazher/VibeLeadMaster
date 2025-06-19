FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1
ENV PORT=10000
WORKDIR /app

# Install Python build tools only if needed
RUN apt-get update && apt-get install -y gcc libffi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY . .

# If you still use entrypoint.sh
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 10000

# Use entrypoint if still present, else run uvicorn directly
ENTRYPOINT ["/app/entrypoint.sh"]
