#!/usr/bin/env groovy

def gv

pipeline {
    tools {
        maven "maven-3.9"
    }
    agent any
    environment {
        IMAG_NAME = "amosa77/demo-app:1.1.8-2"
    }
    stages {

        stage("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }

        stage("BuildApp") {
            steps {
                script {
                    echo "Building the application JAR"
                    sh "mvn clean package"
                }
            }
        }

        stage("Testing") {
            steps {
                script {
                    gv.Testing()
                }
            }
        }

        stage("Build and Push Image") {
            steps {
                script {
                    echo "Building Docker image of the application..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo2', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "docker build -t ${IMAG_NAME} ."
                        sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
                        sh "docker push ${IMAG_NAME}"
                    }
                }
            }
        }

        stage("DeployJAr") {
            steps {
                script {
                    echo "Deploying my Application on EC2 instance..."
                    gv.DeployJAr()

                    def shellCmd = "bash ./server-cmd.sh"
                    sshagent(['Aws-ssh-key']) {
                        sh "scp server-cmd.sh ec2-user@51.20.255.180:/home/ec2-user"
                        sh "scp Docker-compose.yaml ec2-user@51.20.255.180:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@51.20.255.180 ${shellCmd}"
                    }

                }
            }
        }

    }
}
