pipeline {
    agent any

    tools {
        maven 'Maven-3.9.0'
    }

    environment {
        AWS_ACCOUNT_ID = '815210276167' // Replace with your AWS Account ID
        AWS_REGION     = 'us-east-1'     // Replace with your AWS Region
        ECR_REPO       = 'tomcat-demo-ecr'   // Replace with your ECR Repository Name
       // ECS_CLUSTER    = 'my-ecs-cluster'// Replace with your ECS Cluster Name
       // ECS_SERVICE    = 'my-tomcat-service' // Replace with your ECS Service Name
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/regisadjihou/devopscicd_1.git'
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

        stage('Push to ECR') {
            steps {
                script {
                    // Log in to AWS ECR
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                    
                    // Tag and Push the freshly scanned image
                    sh "docker tag tomcat-demo:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"
                }
            }
        }
    }
}