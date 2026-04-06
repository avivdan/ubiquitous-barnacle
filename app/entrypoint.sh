#!/bin/bash
set -e

echo "Waiting for Jenkins master..."
until curl -sf "${JENKINS_URL}/login" > /dev/null; do sleep 15; done

echo "Fetching agent secret..."
SECRET=$(curl -sf -u "admin:${JENKINS_ADMIN_PASSWORD}" \
    "${JENKINS_URL}/computer/${JENKINS_AGENT_NAME}/slave-agent.jnlp" | \
    grep -oP '(?<=<argument>)[a-f0-9]{64}(?=</argument>)' | head -1)

if [ -z "$SECRET" ]; then
    echo "Could not fetch secret, retrying in 10s..."
    sleep 10
    exec "$0"
fi

echo "Connecting..."
exec java -jar /usr/share/jenkins/agent.jar \
    -url "${JENKINS_URL}" \
    -secret "${SECRET}" \
    -name "${JENKINS_AGENT_NAME}" \
    -workDir "/home/jenkins/agent"
