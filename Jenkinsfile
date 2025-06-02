pipeline {
    agent any

    environment {
        IMAGE = 'codeinsightacademy25/my-secure-app'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/CodeInsightAcademy/devsecops-app.git'
            }
        }

        stage('Dependency Vulnerability Check') {
            steps {
                sh '''
                    mkdir -p reports
                    docker run --rm \
                        -v $(pwd):/src \
                        owasp/dependency-check \
                        --project MyApp \
                        --scan /src \
                        --format HTML \
                        --out /src/reports
                '''
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
            archiveArtifacts artifacts: 'reports/**', allowEmptyArchive: true
        }
    }
}
