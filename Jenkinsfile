pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'simple-devops-app'
        DOCKER_TAG = '${BUILD_NUMBER}'
        REGISTRY = 'localhost:5000'  // Local Docker registry
        GIT_REPO = 'https://github.com/YOUR_USERNAME/simple-devops.git'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                // In real scenario, clone from Git
                // git url: "${GIT_REPO}", branch: 'main'
            }
        }

        stage('Build') {
            steps {
                echo 'Building application...'
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'echo "No tests configured yet"'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh '''
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                '''
            }
        }

        stage('Push to Registry') {
            steps {
                echo 'Pushing image to registry...'
                sh '''
                    docker tag ${DOCKER_IMAGE}:latest ${REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                    docker tag ${DOCKER_IMAGE}:latest ${REGISTRY}/${DOCKER_IMAGE}:latest
                    docker push ${REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} || echo "Registry not available, skipping..."
                '''
            }
        }

        stage('Deploy to Minikube') {
            steps {
                echo 'Deploying to Minikube...'
                sh '''
                    # Load image into minikube
                    minikube image load ${DOCKER_IMAGE}:latest
                    
                    # Apply Kubernetes manifests
                    kubectl apply -f k8s/namespace.yaml
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    
                    # Wait for deployment
                    kubectl rollout status deployment/simple-app -n devops-app --timeout=5m
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment...'
                sh '''
                    kubectl get pods -n devops-app
                    kubectl get svc -n devops-app
                    echo "App is available at: http://$(minikube ip):30080"
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed!'
        }
        failure {
            echo 'Pipeline failed - check logs'
        }
        success {
            echo 'Deployment successful!'
        }
    }
}
