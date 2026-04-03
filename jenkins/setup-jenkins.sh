#!/bin/bash

# Jenkins Setup Script
# Run this to install and configure Jenkins locally (requires Docker)

echo "Installing Jenkins for local development..."

# Check if Docker is running
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Create Jenkins volume
docker volume create jenkins_home || echo "Volume already exists"

# Run Jenkins container
echo "Starting Jenkins container..."
docker run -d \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name jenkins \
  jenkins/jenkins:lts

echo "Jenkins is starting up..."
echo ""
echo "Access Jenkins at: http://localhost:8080"
echo ""
echo "To get initial admin password:"
echo "  docker logs jenkins 2>&1 | grep -A5 'Jenkins initial setup'"
echo ""
echo "Or use:"
echo "  docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
echo ""
echo "Setup steps:"
echo "1. Enter the admin password"
echo "2. Select 'Install suggested plugins'"
echo "3. Create admin user"
echo "4. Start using Jenkins"
echo ""
echo "Add pipeline job:"
echo "1. New Item > Pipeline"
echo "2. Name: simple-devops"
echo "3. Pipeline > Definition: Pipeline script from SCM"
echo "4. SCM: Git"
echo "5. Repository URL: file:///path/to/simple-devops/.git"
echo "6. Script Path: Jenkinsfile"
echo ""
echo "TIP: Required Jenkins plugins:"
echo "  - Docker plugin"
echo "  - Kubernetes plugin"
echo "  - Git plugin"
echo "  - Pipeline plugin"
