pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sidhopant/tour-project"
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-creds')  // Docker Hub username & password
        SSH_KEY = credentials('ec2-ssh-key') // SSH key in Jenkins credentials
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "3.7.17.173"
        DEPLOYMENT_NAME = "tour-project"   // K8s deployment name
        CONTAINER_NAME = "tour-project"    // K8s container name
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/siddhopant123/Tour-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin
                    docker push $DOCKER_IMAGE:latest
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sshagent(credentials: ['ec2-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $REMOTE_USER@$REMOTE_HOST '
                            kubectl set image deployment/$DEPLOYMENT_NAME $CONTAINER_NAME=$DOCKER_IMAGE:latest --record || true
                            kubectl rollout status deployment/$DEPLOYMENT_NAME || kubectl apply -f k8s-deployment.yaml
                        '
                    """
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
