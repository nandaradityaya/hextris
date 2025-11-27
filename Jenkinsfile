pipeline {
    agent any

    stages {
        stage('Pull SCM') {
            steps {
                git branch: 'gh-pages', url: 'https://github.com/nandaradityaya/hextris.git'
            }
        }
        
        stage('Containerized Apps') {
            steps {
                sh'''
                docker build -t nandaradityaya/web-hextris-image:latest .
                '''
            }
        }

        stage('Push to Registry') {
            steps {
                sh'''
                docker push nandaradityaya/web-hextris-image:latest
                '''
            }
        }

        stage('Deploy Apps') {
            steps {
                sh'''
                kubectl apply -f manifest/
                '''
            }
        }   
    }
}
