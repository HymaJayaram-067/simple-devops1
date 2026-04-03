#!/bin/bash

# ArgoCD Installation Script for Minikube
echo "Installing ArgoCD..."

# Create namespace
kubectl create namespace argocd || echo "Namespace already exists"

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Port forward to access ArgoCD UI
echo "ArgoCD installed!"
echo "To access ArgoCD UI:"
echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "  Then open: https://localhost:8080"
echo ""
echo "Default username: admin"
echo "To get admin password:"
echo "  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
