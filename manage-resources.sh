#!/bin/bash

# System Resource Management Script
# Use this if you're running out of memory

echo "=== DevOps Lab - Memory Management ==="
echo ""

# Check current system resources
echo "Current System Resources:"
free -h
echo ""

# Clean up Docker
echo "Cleaning up Docker resources..."
docker system prune -f
echo "Docker cleanup complete"
echo ""

# Minikube optimization
echo "Optimizing Minikube..."
echo "Current Minikube status:"
minikube status
echo ""

# If memory is critical
AVAILABLE_MEM=$(free -h | grep Mem | awk '{print $7}' | sed 's/Gi$//')

if (( $(echo "$AVAILABLE_MEM < 0.5" | bc -l) )); then
    echo "WARNING: Low memory available (< 512MB)"
    echo "Reducing Minikube memory allocation..."
    
    # Stop and restart with minimal memory
    minikube stop
    minikube delete
    minikube start --memory=1024 --cpus=2
    
    echo "Minikube restarted with minimal configuration"
fi

echo ""
echo "=== Tips to free up memory ==="
echo "1. Close unnecessary applications"
echo "2. Stop running Docker containers: docker stop \$(docker ps -q)"
echo "3. Stop Minikube: minikube stop"
echo "4. Clean Docker images: docker image prune -a"
echo "5. Restart system"
echo ""
