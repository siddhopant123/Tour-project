pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'Tour-image'
        DOCKER_TAG = 'Tour-project-img'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Timeout wrapper for the checkout step
                    timeout(time: 10, unit: 'MINUTES') {
                        // Checkout code from GitHub using credentials
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: '*/main']],
                            doGenerateSubmoduleConfigurations: false,
                            extensions: [],
                            userRemoteConfigs: [[
                                url: 'https://github.com/siddhopant123/Tour-project.git',
                                credentialsId: '3f630e32-de75-421e-8362-00472c056752' // Replace with your Jenkins credentials ID for GitHub PAT
                            ]]
                        ])
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    def customImage = docker.build("${env.DOCKER_IMAGE}:${env.DOCKER_TAG}")
                }
            }
        }
    }
}
