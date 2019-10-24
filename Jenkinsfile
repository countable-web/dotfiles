pipeline {
    agent { label 'bool.countable.ca' }
    stages {
        stage('Clone repository') {
            checkout scm
        }
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                sh './ci.sh'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}

