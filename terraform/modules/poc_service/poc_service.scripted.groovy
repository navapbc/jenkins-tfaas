node {
    stage('Preparation') { // for display purposes
        sh 'date'
        currentBuild.displayName = "poc v1.2.3"
    }
    stage('Build') {
        sh 'date'
    }
    stage('Results') {
        sh 'date'
    }
}
