pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'tour-sid'
        DOCKER_TAG = 'tour-sid-img'
        DOCKER_REGISTRY_CREDENTIALS = 'docker-hub-credentials' // Docker Hub credentials ID
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    timeout(time: 10, unit: 'MINUTES') {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: '*/main']],
                            doGenerateSubmoduleConfigurations: false,
                            extensions: [],
                            userRemoteConfigs: [[
                                url: 'https://github.com/siddhopant123/Tour-project.git',
                                credentialsId: '3f630e32-de75-421e-8362-00472c056752'
                            ]]
                        ])
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("sidhopant/${env.DOCKER_IMAGE}:${env.DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_REGISTRY_CREDENTIALS) {
                        docker.image("sidhopant/${env.DOCKER_IMAGE}:${env.DOCKER_TAG}").push()
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
                        docker pull sidhopant/${env.DOCKER_IMAGE}:${env.DOCKER_TAG}
                        docker run -dp 127.0.0.1:8098:80 --name tour-container sidhopant/${env.DOCKER_IMAGE}:${env.DOCKER_TAG}
                    """
                }
            }
        }
    }
}
