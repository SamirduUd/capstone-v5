@Library('github.com/releaseworks/jenkinslib') _

pipeline {
  environment {
    registry = '8if8troin6i4rv2p/capstone-v5'
    dockerCredential = 'dockerhub-user'
    dockerImage = ''
    def kubClusterName = 'cpastone-kub-cluster'
    def kubClusterConfig = 'deployApp-blue-params.yml'
    awsRegion = 'us-east-2'
    //awsCredentials = 'aws-key'
  }

  agent any
  stages {
    stage('Cloning Capstone Project from Github') {
      steps {
        git 'https://github.com/SamirduUd/capstone-v4.git'
      }
    }
    
  stage('Lint HTML') {
      steps {
        sh 'tidy -q -e index.html'
      }
    }

    stage('Building Docker Image') {
      steps {
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }

    stage('Push Docker Image') {
      steps {
        script {
          docker.withRegistry( '', dockerCredential ) {
            dockerImage.push()
          }
        }

      }
    }

    stage('Deploy into AWS Kub Cluster') {
      steps{
        sh 'pwd'
      }
    }

    stage('Cleaning up') {
      steps {
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
  }
}