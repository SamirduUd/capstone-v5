@Library('github.com/releaseworks/jenkinslib') _

pipeline {
  environment {
    registry = '8if8troin6i4rv2p/capstone-v5'
    dockerCredential = 'dockerhub-user'
    dockerImage = ''
    def kubClusterName = 'kubClusterForCapstoneProject'
    def kubClusterConfig = 'deployApp-params.yml'
    aws-region = 'us-east-2'
    //awsCredentials = 'aws-key'
  }

  agent any
  stages {
    stage('Cloning Capstone Project from Github') {
      steps {
        git 'https://github.com/SamirduUd/capstone-v4.git'
      }
    }
    
    stage('Create kub Cluster') {
      steps {
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]){
        AWS("--region=us-east-2 eksctl create cluster --name ${kubClusterName} --nodegroup-name myNodes --node-type t2.medium --nodes 2 --nodes-min 1 --nodes-max 2 --node-ami auto --region aws-region")
        }
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

    stage('Deploy to Kub Cluster') {
              steps{
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                  AWS("--region=us-east-2 eks update-kubeconfig --name ${kubClusterForCapstoneProject}")
                  AWS("--region=us-east-2 kubectl apply -f ${kubClusterConfig}")
                  AWS("--region=us-east-2 kubectl get deployments")
                  }
              }
        }


  }
}