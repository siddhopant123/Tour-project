pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sidhopant/tour-project"
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-creds')  // Docker Hub username & password
        KUBECONFIG = credentials('kubeconfig-dev')               // kubeconfig secret from Jenkins
        DEPLOYMENT_NAME = "tour-project"
        CONTAINER_NAME = "tour-project"
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
                withKubeConfig([credentialsId: 'kubeconfig-dev']) {
                    sh """
                        kubectl set image deployment/$DEPLOYMENT_NAME $CONTAINER_NAME=$DOCKER_IMAGE:latest --record || true
                        kubectl rollout status deployment/$DEPLOYMENT_NAME
                        kubectl apply -f k8s-deployment.yaml
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
