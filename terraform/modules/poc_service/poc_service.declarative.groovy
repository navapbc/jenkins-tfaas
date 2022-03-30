pipeline {
    agent any
    stages {
        stage('Preparation') { // for display purposes
            steps {
                sh 'date'

            }

        }
        stage('Build') {
            steps {
                sh 'date'
            }

        }
        stage('Results') {
            steps {
                sh 'date'
            }
        }

    }
}
