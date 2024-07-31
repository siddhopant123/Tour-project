pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'tour-image'
        DOCKER_REGISTRY_CREDENTIALS = 'docker-hub-credentials' // Docker Hub credentials ID
        VERSION_FILE = 'version.txt'
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

        stage('Determine Version') {
            steps {
                script {
                    // Create the version file if it doesn't exist
                    if (!fileExists(env.VERSION_FILE)) {
                        writeFile file: env.VERSION_FILE, text: '0.0.0.0.0.0'
                    }

                    // Read the current version from the file
                    def version = readFile(env.VERSION_FILE).trim()

                    // Split the version and increment the last segment
                    def versionParts = version.tokenize('.')
                    versionParts[-1] = (versionParts[-1].toInteger() + 1).toString()

                    // Join the parts to form the new version
                    env.DOCKER_TAG = versionParts.join('.')

                    // Save the new version to the file
                    writeFile file: env.VERSION_FILE, text: env.DOCKER_TAG

                    // Print the new version
                    echo "New Docker image version: ${env.DOCKER_TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.DOCKER_IMAGE}:${env.DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
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
