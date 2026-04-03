@echo off
REM Simple DevOps Project - Windows Setup Script
REM Run this script to set up the entire project on Minikube

setlocal enabledelayedexpansion

echo =================================
echo Simple DevOps Project Setup
echo =================================
echo.

echo Checking prerequisites...
where minikube >nul 2>&1 || (echo Minikube not found. Please install it. && exit /b 1)
where kubectl >nul 2>&1 || (echo kubectl not found. Please install it. && exit /b 1)
where docker >nul 2>&1 || (echo Docker not found. Please install it. && exit /b 1)

echo [OK] All prerequisites found
echo.

echo Starting Minikube...
minikube start --memory=2048 --cpus=2
echo [OK] Minikube started
echo.

echo Building Docker image...
docker build -t simple-devops-app:latest .
echo [OK] Docker image built
echo.

echo Loading image into Minikube...
minikube image load simple-devops-app:latest
echo [OK] Image loaded
echo.

echo Deploying to Kubernetes...
kubectl apply -f k8s\namespace.yaml
kubectl apply -f k8s\deployment.yaml
kubectl apply -f k8s\service.yaml
echo [OK] Deployment created
echo.

echo Waiting for deployment to be ready...
kubectl rollout status deployment/simple-app -n devops-app --timeout=5m
echo [OK] Deployment ready
echo.

echo Deployment Status:
kubectl get pods -n devops-app
echo.
kubectl get svc -n devops-app
echo.

for /f "tokens=*" %%i in ('minikube ip') do set MINIKUBE_IP=%%i

echo ==================================
echo Setup Complete!
echo ==================================
echo.
echo Application is running!
echo.
echo Access the application:
echo   URL: http://%MINIKUBE_IP%:30080
echo   Health: http://%MINIKUBE_IP%:30080/health
echo   Version: http://%MINIKUBE_IP%:30080/version
echo.
echo Or use port forwarding:
echo   kubectl port-forward -n devops-app svc/simple-app-service 3000:3000
echo   Then access: http://localhost:3000
echo.
echo Useful commands:
echo   View pods: kubectl get pods -n devops-app
echo   View logs: kubectl logs -n devops-app -l app=simple-app
echo   Dashboard: minikube dashboard
echo.
