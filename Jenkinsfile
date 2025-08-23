pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sidhopant/tour-project"
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-creds')  // Docker Hub username & password
        SSH_KEY = credentials('ec2-ssh-key') // your devops-key.pem added in Jenkins credentials
        REMOTE_USER = "ubuntu"
        REMOTE_HOST = "3.7.17.173"
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
                sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push $DOCKER_IMAGE:latest'
            }
        }

        stage('Deploy on EC2') {
            steps {
                sshagent(credentials: ['ec2-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $REMOTE_USER@$REMOTE_HOST '
                            docker pull $DOCKER_IMAGE:latest &&
                            docker stop tour-project || true &&
                            docker rm tour-project || true &&
                            docker run -d --name tour-project -p 80:80 $DOCKER_IMAGE:latest
                        '
                    """
                }
            }
        }
    }
}
