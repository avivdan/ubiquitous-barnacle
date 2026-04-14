pipeline {
    agent {label 'linux'}
    environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }
    stages {
        stage('git checkout') {
             steps {
                git branch: 'main', url: 'https://github.com/avivdan/ubiquitous-barnacle.git'
            }
        }
        stage('Lint check ') {
            steps {
                sh 'python3 -m flake8 app/app.py --exit-zero --format=pylint --output-file=flake8.log'
            }
        }
        stage('Run tests') {
            steps {
                sh 'docker compose --profile test run --rm app-test'
            }
        }
        stage('Build Docker image') {
            steps {
                sh 'docker compose build app'
            }
        }
        stage('Push Docker image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    sh 'docker tag app:latest ${DOCKER_USERNAME}/app:latest'
                    sh 'docker push ${DOCKER_USERNAME}/app:latest'
                }
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    sh 'cd /home/ubuntu/project && docker compose pull app && docker compose up -d app'
                }
            }
        }
    }
}