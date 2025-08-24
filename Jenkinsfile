pipeline {
    agent any

    environment {
        DOCKER_USERNAME = credentials('docker-username') // Jenkins secret
        DOCKER_PASSWORD = credentials('docker-password') // Jenkins secret
        DOCKER_IMAGE    = "sidhopant/tour-project:latest"
        REMOTE_USER     = "ubuntu"
        REMOTE_HOST     = "3.7.17.173" // Your EC2 IP
        REMOTE_MANIFEST = "/home/ubuntu/k8s-deployment.yaml"
    }

    stages {
        stage('Build & Push Docker Image') {
            steps {
                script {
                    sh """
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker build -t ${DOCKER_IMAGE} .
                        docker push ${DOCKER_IMAGE}
                        docker logout
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sshagent(['ubuntu']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $REMOTE_USER@$REMOTE_HOST '
                            # Apply manifest using microk8s kubectl
                            microk8s.kubectl apply -f ${REMOTE_MANIFEST}
                        '
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Deployment completed successfully!"
        }
        failure {
            echo "Deployment failed. Check logs!"
        }
    }
}
