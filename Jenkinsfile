pipeline {
    agent any

    environment {
        IMAGE_NAME = "sidhopant/tour-project"
        IMAGE_TAG  = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )]) {
                    sh """
                        echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker logout
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Docker image pushed successfully: ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Build/Push failed. Check Jenkins logs!"
        }
    }
}
