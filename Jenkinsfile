pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nandaradityaya/web-hextris-image"
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
                echo "Building Docker image..."
                sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
            }
        }


        stage('Push Docker Image') {
            steps {
                sh """
                    docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                    docker push ${DOCKER_IMAGE}:latest
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                    sh """
                        export KUBECONFIG=${KUBECONFIG_FILE}
                        kubectl -n ${NAMESPACE} apply -f deployment.yaml
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
