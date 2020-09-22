@Library('github.com/releaseworks/jenkinslib') _

pipeline {
  environment {
    registry = '8if8troin6i4rv2p/capstone-v5'
    dockerCredential = 'dockerhub-user'
    dockerImage = ''
    def kubClusterName = 'capastone-kub-cluster'
    def kubClusterParams = 'create-kub-cluster-params.yml'
    def appConfig = 'deployApp-blue-params.yml'
    awsRegion = 'us-east-2'
  }

  agent any
  stages {
    stage('Cloning Capstone Project from Github') {
      steps {
        git 'https://github.com/SamirduUd/capstone-v5.git'
      }
    }

    stage('Create Kubernetes EKS Cluster') {
      steps {
        sh 'eksctl create cluster -f ${kubClusterParams}'
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
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]){
        AWS("--region=us-east-2 aws eks update-kubeconfig --name ${kubClusterName}")

        AWS("--region=us-east-2 kubectl apply -f ${appConfig}")

        AWS("kubectl rollout status deployment.apps/deploy-blue")        
      }
    }

    stage('Cleaning up') {
      steps {
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
  }
}