node {
    stage('Preparation') { // for display purposes
        sh 'date'
        currentBuild.displayName = "[poc_service-v1.2.3] TF: 0/3/0"
    }
    stage('TF Plan') {
        sh 'date'
    }
    stage('TF Apply') {
        sh 'date'
    }
    stage('TF Post-Plan') {        
        sh 'date'
    }
}
