pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'sidhopant/tour-image-sid'  // Docker Hub image name
        DOCKER_REGISTRY_CREDENTIALS = 'docker-hub-credentials'  // Docker Hub credentials ID
        VERSION_FILE = 'version.txt'
        GIT_CREDENTIALS_ID = 'github-credentials'  // GitHub credentials ID
        BRANCH_NAME = 'main'  // Branch name
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
                    // Ensure the version file exists and update the version
                    def version = fileExists(env.VERSION_FILE) ? readFile(env.VERSION_FILE).trim() : '0.0.0'
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
                        .push()
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
