@Library('github.com/releaseworks/jenkinslib') _

pipeline {
  environment {
    registry = '8if8troin6i4rv2p/capstone-v3'
    dockerCredential = 'dockerhub-user'
    dockerImage = ''
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

    stage('Create App network in AWS') {
      steps {
        //withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]){
        //AWS("--region=us-east-2 cloudformation create-stack --stack-name CreateNetwork --template-body file://network.yml --parameters file://network-params.json --capabilities CAPABILITY_NAMED_IAM")
        sh "ls"
        //}
      }
    }

    stage('Create Blue EC2 Machines') {
      steps {
        //withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        //AWS("--region=us-east-2 cloudformation create-stack --stack-name CreateBlueHosts --template-body file://blue-servers.yml --parameters file://blue-servers-params.json --capabilities CAPABILITY_NAMED_IAM")
        sh "ls"
        //}
      }
    }

    stage('Create Green EC2 Machines') {
      steps {
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        AWS("--region=us-east-2 cloudformation create-stack --stack-name CreateGreenHosts --template-body file://green-servers.yml --parameters file://green-servers-params.json --capabilities CAPABILITY_NAMED_IAM")
        }
      }
    }

    stage('Deploy App on Blue') {
      steps {
        sh "ls"
      }
    }
  }
}