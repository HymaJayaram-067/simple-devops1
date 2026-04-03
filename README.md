# Simple DevOps Learning Project

A minimal end-to-end DevOps project demonstrating:
- **Docker**: Containerizing a Node.js application
- **Kubernetes/Minikube**: Orchestrating containers
- **Jenkins**: CI/CD pipeline automation
- **ArgoCD**: GitOps-based deployment

## Project Structure

```
simple-devops/
├── app.js                 # Simple Node.js application
├── package.json          # Node.js dependencies
├── Dockerfile            # Docker image definition
├── .dockerignore         # Docker build exclusions
├── Jenkinsfile           # Jenkins CI/CD pipeline
├── k8s/                  # Kubernetes manifests
│   ├── namespace.yaml    # Create devops-app namespace
│   ├── deployment.yaml   # Application deployment
│   └── service.yaml      # Expose service
├── argocd/               # ArgoCD configuration
│   ├── application.yaml  # ArgoCD app definition
│   └── install-argocd.sh # ArgoCD setup script
└── README.md            # This file
```

## System Requirements

- **Minikube**: Local Kubernetes cluster
- **Docker**: Container runtime
- **kubectl**: Kubernetes CLI
- **Jenkins**: CI/CD automation (optional for learning)
- **ArgoCD**: GitOps tool (optional setup)
- **RAM**: Minimum 2GB free (optimized for resource constraints)

## Quick Start

### 1. Build Docker Image

```bash
cd simple-devops
docker build -t simple-devops-app:latest .
```

### 2. Load into Minikube

```bash
minikube image load simple-devops-app:latest
```

### 3. Deploy to Minikube

```bash
# Create namespace
kubectl apply -f k8s/namespace.yaml

# Deploy application
kubectl apply -f k8s/deployment.yaml

# Expose service
kubectl apply -f k8s/service.yaml
```

### 4. Access the Application

```bash
# Get Minikube IP
minikube ip

# Access app
curl http://<MINIKUBE_IP>:30080

# Or use port forwarding
kubectl port-forward -n devops-app svc/simple-app-service 3000:3000
curl http://localhost:3000
```

### 5. Check Deployment Status

```bash
# View pods
kubectl get pods -n devops-app

# View services
kubectl get svc -n devops-app

# View logs
kubectl logs -n devops-app -l app=simple-app
```

## Available Endpoints

- **GET /?** - Main endpoint, returns app status
- **GET /health** - Health check endpoint (used by Kubernetes)
- **GET /version** - Application version info

## Setting up Jenkins

### Option 1: Install Jenkins on Host

```bash
# Using Docker
docker run -d \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  --name jenkins \
  jenkins/jenkins:lts
```

### Option 2: Install Jenkins as Kubernetes Pod

```bash
kubectl apply -f jenkins-k8s.yaml  # If available
```

### Configure Jenkins

1. Access Jenkins at `http://localhost:8080`
2. Get initial admin password: Check docker logs or container
3. Create a new Pipeline job
4. Set repository URL to your git repo
5. Set Jenkinsfile path: `Jenkinsfile`
6. Configure webhook for auto-trigger

## Setting up ArgoCD

### Installation

```bash
bash argocd/install-argocd.sh
```

### Access ArgoCD

```bash
# Port forward
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

Visit `https://localhost:8080` (accept self-signed cert)

### Add Application to ArgoCD

```bash
# Apply the application manifest
kubectl apply -f argocd/application.yaml
```

## Monitoring

### View Kubernetes Dashboard

```bash
minikube dashboard
```

### Watch Deployment

```bash
kubectl get pods -n devops-app -w
```

### Real-time Logs

```bash
kubectl logs -n devops-app -l app=simple-app -f
```

## Resource Optimization

For systems with limited RAM (< 4GB):

- Deployment replicas reduced to 2
- Resource requests/limits set low:
  - Memory request: 64Mi, limit: 128Mi
  - CPU request: 100m, limit: 250m
- Node.js Alpine image (lightweight base)
- Minikube configured with `--memory=1024`

## Troubleshooting

### Out of Memory
```bash
# Free up space
minikube delete
docker system prune -a
minikube start --memory=2048
```

### Pod not starting
```bash
# Check pod status
kubectl describe pod <pod-name> -n devops-app

# Check logs
kubectl logs <pod-name> -n devops-app
```

### Image not found
```bash
# Ensure image is loaded in minikube
minikube image load simple-devops-app:latest

# Or rebuild and load
docker build -t simple-devops-app:latest .
minikube image load simple-devops-app:latest
```

## Next Steps for Learning

1. **Add tests** - Implement unit tests in Jenkins pipeline
2. **Multi-stage deployment** - Dev → Staging → Production
3. **Helm charts** - Package Kubernetes manifests
4. **Monitoring** - Add Prometheus/Grafana
5. **GitOps** - Full ArgoCD automation
6. **Private registry** - Use Docker Hub or registry
7. **Secrets management** - Add sealed-secrets or external-secrets

## Useful Commands

```bash
# Minikube
minikube start --memory=2048 --cpus=2
minikube stop
minikube delete
minikube ip
minikube dashboard

# Kubernetes
kubectl cluster-info
kubectl get nodes
kubectl get all -A
kubectl describe pod <pod-name> -n <namespace>
kubectl delete pod <pod-name> -n <namespace>

# Docker
docker ps
docker images
docker logs <container-id>
docker inspect <container-id>

# Jenkins
# Access at http://localhost:8080
# View logs: docker logs jenkins

# ArgoCD
# Access at https://localhost:8080 (after port-forward)
# CLI: argocd app list
# CLI: argocd app get simple-devops-app
```

## License

MIT - Feel free to modify for learning purposes

## Support

For issues or questions, refer to:
- [Kubernetes Docs](https://kubernetes.io/docs)
- [Docker Docs](https://docs.docker.com)
- [Minikube Docs](https://minikube.sigs.k8s.io)
- [Jenkins Docs](https://www.jenkins.io/doc)
- [ArgoCD Docs](https://argoproj.github.io/argo-cd)
