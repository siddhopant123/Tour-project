pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'sidhopant/tour-image-sid'
        DOCKER_REGISTRY_CREDENTIALS = 'docker-hub-credentials'
        VERSION_FILE = 'version.txt'
        BRANCH_NAME = 'main'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Determine Version') {
            steps {
                script {
                    def version = fileExists(env.VERSION_FILE) ? readFile(env.VERSION_FILE).trim() : '0.0.0.0.0.0'
                    def versionParts = version.tokenize('.')
                    versionParts[-1] = (versionParts[-1].toInteger() + 1).toString()
                    env.DOCKER_TAG = versionParts.join('.')
                    writeFile file: env.VERSION_FILE, text: env.DOCKER_TAG
                    echo "New Docker image version: ${env.DOCKER_TAG}"
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    docker.build("${env.DOCKER_IMAGE}:${env.DOCKER_TAG}")
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_REGISTRY_CREDENTIALS) {
                        docker.image("${env.DOCKER_IMAGE}:${env.DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy Docker Image') {
            steps {
                script {
                    sh """
                        docker stop tour-container || true
                        docker rm tour-container || true
                        docker pull ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}
                        docker run -dp 127.0.0.1:8098:80 --name tour-container ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}
                    """
                }
            }
        }
    }
}
