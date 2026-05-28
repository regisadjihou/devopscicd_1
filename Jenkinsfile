pipeline {
    agent any

    tools {
        maven 'Maven-3.9.0'
    }

    environment {
        AWS_ACCOUNT_ID = '815210276167' 
        AWS_REGION     = 'us-east-1'     
        ECR_REPO       = 'tomcat-demo-ecr'   
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/regisadjihou/devopscicd_1.git'
            }
        }

        stage('Build WAR Artifact') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t tomcat-demo .'
            }
        }

        stage('SonarQube Quality Gate') {
            steps {
                script {
                    // Fix 1: Explicitly capture the scanner tool directory path
                    def scannerHome = tool 'sonar-scanner'
                    
                    withSonarQubeEnv('My-SonarQube-Server') { 
                        // Call the binary directly via its absolute installation path
                        sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=tomcat-demo \
                            -Dsonar.sources=. \
                            -Dsonar.java.binaries=."
                    }
                }
                // Timeout adjusted to a reasonable 15 minutes to prevent hung executor threads
                timeout(time: 15, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    // Log in to AWS ECR
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                    
                    // Tag and Push the image
                    sh "docker tag tomcat-demo:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"
                }
            }
        }
    }

    post {
        always {
            // Fix 2: Changed to triple double-quotes (""") so Jenkins expands the AWS and repo environment variables
            sh """
            docker rmi tomcat-demo:latest || true
            docker rmi ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest || true
            docker image prune -f
            """
        }
    }
}