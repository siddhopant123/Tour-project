pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sidhopant/tour-project"
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-creds')
        KUBECONFIG = credentials('kubeconfig-file')
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

        stage('Deploy to Kubernetes') {
            steps {
                writeFile file: 'kubeconfig', text: "${KUBECONFIG}"
                sh '''
                  export KUBECONFIG=kubeconfig
                  kubectl apply -f k8s-deployment.yaml
                  kubectl set image deployment/tour-project tour-project=$DOCKER_IMAGE:latest --record
                  kubectl rollout status deployment/tour-project
                '''
            }
        }
    }
}
