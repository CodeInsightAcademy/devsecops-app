pipeline {
    agent any

    tools {
        maven 'Maven 3' // or use Python if it's a Python app
    }

    environment {
        IMAGE = 'codeinsightacademy25/my-secure-app'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/CodeInsightAcademy/devsecops-app.git'
            }
        }

        stage('Dependency Vulnerability Check') {
            steps {
                sh 'dependency-check.sh --project MyApp --scan . --format HTML'
            }
        }

        stage('Static Code Analysis') {
            steps {
                sh 'sonar-scanner'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }

        stage('Image Vulnerability Scan') {
            steps {
                sh 'trivy image $IMAGE'
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $IMAGE'
                }
            }
        }

        stage('Deploy to Test Environment') {
            steps {
                sh 'docker run -d -p 5000:5000 $IMAGE'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/dependency-check-report.html', allowEmptyArchive: true
        }
    }
}
