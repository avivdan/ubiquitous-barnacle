FROM python:3.12-slim AS base

WORKDIR /app

ENV PYTHONPATH=/app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Test stage
FROM base AS test
RUN pytest tests/test_app.py

# Production stage
FROM base AS production
EXPOSE 5000
CMD ["python", "app.py"]

# Jenkins agent stage
FROM jenkins/inbound-agent:latest-jdk21 AS agent

USER root

RUN apt-get update && apt-get install -y \
    ca-certificates curl lsb-release && \
    curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
        https://download.docker.com/linux/debian/gpg && \
    echo "deb [arch=$(dpkg --print-architecture) \
        signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
        https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y docker-ce-cli docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER jenkins
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
