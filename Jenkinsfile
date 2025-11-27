pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')     // Credentials ID di Jenkins
        DOCKER_IMAGE = "nandaradityaya/web-hextris-image"
        KUBE_CONFIG = credentials('kube-config')                  // kubeconfig cluster K8s
        NAMESPACE = "exam"
    }

    stages {

        stage('Pull SCM') {
            steps {
                echo "Pulling source code..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker Image..."
                sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
            }
        }

        stage('Login to Docker Hub') {
            steps {
                sh """
                    echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image..."
                sh """
                    docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                    docker push ${DOCKER_IMAGE}:latest
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying to Kubernetes..."

                sh """
                    echo "${KUBE_CONFIG}" > kubeconfig
                    export KUBECONFIG=kubeconfig
                """

                sh """
                    kubectl -n ${NAMESPACE} apply -f deployment.yaml
                """

                sh """
                    kubectl -n ${NAMESPACE} rollout restart deployment hextris-app
                """
            }
        }
    }

    post {
        always {
            echo "Cleaning up workspace..."
        }
    }
}
