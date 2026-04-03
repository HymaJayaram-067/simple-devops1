#!/bin/bash

# Simple DevOps Project - Complete Setup Script
# Run this script to set up the entire project on Minikube

set -e

echo "=== Simple DevOps Project Setup ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"
command -v minikube >/dev/null 2>&1 || { echo "Minikube not found. Please install it."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found. Please install it."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "Docker not found. Please install it."; exit 1; }

echo -e "${GREEN}✓ All prerequisites found${NC}"
echo ""

# Start Minikube
echo -e "${BLUE}Starting Minikube...${NC}"
minikube start --memory=2048 --cpus=2 || echo "Minikube already running"
eval $(minikube docker-env)
echo -e "${GREEN}✓ Minikube started${NC}"
echo ""

# Build Docker image
echo -e "${BLUE}Building Docker image...${NC}"
docker build -t simple-devops-app:latest .
echo -e "${GREEN}✓ Docker image built${NC}"
echo ""

# Load image into Minikube
echo -e "${BLUE}Loading image into Minikube...${NC}"
minikube image load simple-devops-app:latest
echo -e "${GREEN}✓ Image loaded${NC}"
echo ""

# Deploy to Kubernetes
echo -e "${BLUE}Deploying to Kubernetes...${NC}"
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
echo -e "${GREEN}✓ Deployment created${NC}"
echo ""

# Wait for deployment
echo -e "${BLUE}Waiting for deployment to be ready...${NC}"
kubectl rollout status deployment/simple-app -n devops-app --timeout=5m
echo -e "${GREEN}✓ Deployment ready${NC}"
echo ""

# Display status
echo -e "${BLUE}Deployment Status:${NC}"
kubectl get pods -n devops-app
echo ""
kubectl get svc -n devops-app
echo ""

# Get service URL
MINIKUBE_IP=$(minikube ip)
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "Application is running!"
echo ""
echo -e "${YELLOW}Access the application:${NC}"
echo "  URL: http://${MINIKUBE_IP}:30080"
echo "  Health: http://${MINIKUBE_IP}:30080/health"
echo "  Version: http://${MINIKUBE_IP}:30080/version"
echo ""
echo -e "${YELLOW}Or use port forwarding:${NC}"
echo "  kubectl port-forward -n devops-app svc/simple-app-service 3000:3000"
echo "  Then access: http://localhost:3000"
echo ""
echo -e "${YELLOW}Useful commands:${NC}"
echo "  View pods: kubectl get pods -n devops-app"
echo "  View logs: kubectl logs -n devops-app -l app=simple-app"
echo "  Dashboard: minikube dashboard"
echo ""
echo -e "${YELLOW}Optional - Install ArgoCD:${NC}"
echo "  bash argocd/install-argocd.sh"
echo ""
