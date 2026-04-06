#!/bin/bash
set -e

apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release git

# Install Docker Engine
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# Clone repo
git clone https://github.com/avivdan/ubiquitous-barnacle.git /home/ubuntu/project
chown -R ubuntu:ubuntu /home/ubuntu/project

# Write .env with injected values
cat > /home/ubuntu/project/.env <<EOF
JENKINS_ADMIN_PASSWORD=${jenkins_admin_password}
JENKINS_PORT_WEB=8080
JENKINS_PORT_AGENT=50000
flask_app_port=5000
DOCKER_HUB_USERNAME=${docker_hub_username}
DOCKER_HUB_PASSWORD=${docker_hub_password}
JENKINS_URL=http://${master_private_ip}:8080
JENKINS_AGENT_NAME=docker-agent
EOF

# Start app and agent
cd /home/ubuntu/project
docker compose up -d agent app