pipeline {
  agent any

  environment {
    EC2_HOST = '54.252.194.194'
    SSH_CREDENTIALS_ID = 'EC2_PEM_KEY'
    REPO_URL = 'https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git'
  }

  stages {

    stage('Install dependencies (agent-specific)') {
      steps {
        script {
          if (isUnix()) {
            sh '''
              apt-get update || true
              apt-get install -y curl git ssh python3 python3-venv python3-pip || true
              apt-get install -y nodejs npm || true
            '''
          } else {
            bat 'echo Running on Windows agent - skipping apt-get steps'
          }
        }
      }
    }

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build service-a') {
      steps {
        dir('service-a') {
          script {
            if (isUnix()) {
              sh 'npm ci'
            } else {
              bat 'npm ci'
            }
          }
        }
      }
    }

    stage('Build service-b') {
      steps {
        dir('service-b') {
          script {
            if (isUnix()) {
              sh 'python3 -m venv .venv'
              sh '. .venv/bin/activate && pip install -r requirements.txt'
            } else {
              bat 'python -m venv .venv'
              bat '.venv\\Scripts\\python -m pip install -r requirements.txt'
            }
          }
        }
      }
    }

    stage('Deploy to EC2') {
      steps {
        sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
          script {
            if (isUnix()) {
              sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} 'bash -s' < scripts/deploy_app.sh service-a"
              sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} 'bash -s' < scripts/deploy_app.sh service-b"
            } else {
              bat "type scripts\\deploy_app.sh | ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} 'bash -s'"
              bat "type scripts\\deploy_app.sh | ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} 'bash -s' service-b"
            }
          }
        }
      }
    }
  }
}
