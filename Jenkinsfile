pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Fetching portfolio source code from GitHub'
                git branch: 'main',
                    url: 'https://github.com/swatii2011/DevOps-Portfolio.git'
            }
        }

        stage('Verify Source Code') {
            steps {
                echo 'Checking downloaded files'
                sh 'ls -la'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building portfolio Docker image'
                sh 'docker build -t swati-portfolio:jenkins .'
            }
        }

        stage('Deployment Status') {
            steps {
                echo 'Portfolio Docker image built successfully!'
            }
        }
    }
}