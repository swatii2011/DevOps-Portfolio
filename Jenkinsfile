
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

        stage('Verify AWS Access') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-credentials',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        export AWS_DEFAULT_REGION=us-east-1
                        aws sts get-caller-identity
                        aws ec2 describe-instances \
                            --instance-ids i-0330463e945936f64 \
                            --query "Reservations[0].Instances[0].State.Name" \
                            --output text
                    '''
                }
            }
        }

        stage('Verify EC2 SSH') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'ec2-ssh-key',
                        variable: 'SSH_KEY'
                    )
                ]) {
                    sh '''
                        chmod 600 "$SSH_KEY"
                        ssh -o StrictHostKeyChecking=accept-new \
                            -o ConnectTimeout=15 \
                            -i "$SSH_KEY" \
                            ec2-user@54.89.105.196 \
                            "echo SSH connection successful"
                    '''
                }
            }
        }

        stage('Deployment Status') {
            steps {
                echo 'AWS and EC2 connectivity verified successfully!'
            }
        }
    }
}
