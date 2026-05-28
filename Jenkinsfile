pipeline {
    agent any

    tools {
        maven 'Maven-3.9.0'
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
    }
}