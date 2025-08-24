pipeline {
    agent any

    environment {
        IMAGE_NAME = "sidhopant/tour-project:latest"
        K8S_DEPLOYMENT = "tour-project"
        K8S_MANIFEST_PATH = "/home/ubuntu/k8s-deployment.yaml" // path on EC2 instance
        EC2_USER = "ubuntu"
        EC2_HOST = "3.7.17.173" // replace with your EC2 IP
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/siddhopant123/Tour-project.git'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(
                                    credentialsId: 'dockerhub-creds', 
                                    usernameVariable: 'DOCKER_USERNAME', 
                                    passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        docker build -t $IMAGE_NAME .
                        docker push $IMAGE_NAME
                        docker logout
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    withCredentials([file(credentialsId: 'kubeconfig-dev', variable: 'KUBECONFIG_FILE')]) {
                        sh '''
                            scp -o StrictHostKeyChecking=no $KUBECONFIG_FILE $EC2_USER@$EC2_HOST:/home/ubuntu/.kube/config
                            ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "
                                export KUBECONFIG=/home/ubuntu/.kube/config
                                kubectl set image deployment/$K8S_DEPLOYMENT $K8S_DEPLOYMENT=$IMAGE_NAME --record || true
                                kubectl rollout status deployment/$K8S_DEPLOYMENT || true
                                kubectl apply -f $K8S_MANIFEST_PATH
                            "
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed. Check logs!'
        }
    }
}
