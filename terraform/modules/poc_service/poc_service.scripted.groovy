node {
    stage('Preparation') { // for display purposes
        sh 'date'
        currentBuild.displayName = "poc v1.2.3 TF: 0/3/0"
    }
    stage('Build') {
        sh 'date'
    }
    stage('Results') {
        sh 'date'
    }
}
