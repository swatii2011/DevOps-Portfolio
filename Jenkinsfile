
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Fetching latest portfolio code from GitHub'
                git branch: 'main',
                    url: 'https://github.com/swatii2011/DevOps-Portfolio.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building portfolio Docker image'
                sh 'docker build -t swati-portfolio:jenkins .'
            }
        }

        stage('Provision AWS Infrastructure') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-credentials',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    script {
                        dir('terraform') {
                            sh '''
                                set -e
                                export AWS_DEFAULT_REGION=us-east-1
                                terraform init -input=false
                                terraform plan -input=false -out=tfplan
                                terraform apply -input=false -auto-approve tfplan
                            '''

                            env.EC2_IP = sh(
                                script: 'terraform output -raw ec2_public_ip',
                                returnStdout: true
                            ).trim()
                        }
                    }
                }

                echo "EC2 public IP: ${env.EC2_IP}"
            }
        }

        stage('Deploy Portfolio to EC2') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'ec2-ssh-key',
                        variable: 'SSH_KEY'
                    )
                ]) {
                    sh '''
                        #!/bin/bash
                        set -euo pipefail

                        chmod 600 "$SSH_KEY"

                        echo "Waiting for EC2 Docker service..."

                        READY=false

                        for i in $(seq 1 30); do
                            if ssh \
                                -o StrictHostKeyChecking=accept-new \
                                -o ConnectTimeout=10 \
                                -i "$SSH_KEY" \
                                "ec2-user@$EC2_IP" \
                                "sudo docker info >/dev/null 2>&1"; then
                                READY=true
                                break
                            fi

                            echo "Waiting for EC2... attempt $i/30"
                            sleep 10
                        done

                        if [ "$READY" != "true" ]; then
                            echo "EC2 Docker service did not become ready."
                            exit 1
                        fi

                        echo "Transferring Docker image to EC2..."

                        docker save swati-portfolio:jenkins | gzip -1 | ssh \
                            -o StrictHostKeyChecking=accept-new \
                            -i "$SSH_KEY" \
                            "ec2-user@$EC2_IP" \
                            "gunzip | sudo docker load"

                        echo "Replacing the old portfolio container..."

                        ssh \
                            -o StrictHostKeyChecking=accept-new \
                            -i "$SSH_KEY" \
                            "ec2-user@$EC2_IP" \
                            "sudo docker rm -f swati-portfolio >/dev/null 2>&1 || true; sudo docker run -d --name swati-portfolio -p 80:80 --restart unless-stopped swati-portfolio:jenkins"

                        echo "Verifying deployment..."

                        ssh \
                            -o StrictHostKeyChecking=accept-new \
                            -i "$SSH_KEY" \
                            "ec2-user@$EC2_IP" \
                            "curl -fsS http://localhost/ >/dev/null && sudo docker ps --filter name=swati-portfolio"

                        echo "Portfolio deployed successfully!"
                        echo "Website URL: http://$EC2_IP"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "SUCCESS: Portfolio deployment completed."
            echo "Visit: http://${env.EC2_IP}"
        }

        failure {
            echo 'Deployment failed. Check the Jenkins Console Output for the failed stage.'
        }
    }
}
