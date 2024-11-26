pipeline {
 agent {
    lable 'AGENT-1'
 }
 options {
    timeout(time: 30, unit: 'MINUTES')
    disableConcurrentBuilds()
 }
 stages {
    stage('Init') {
        stpes {
            sh """
             ls -ltr
            """
        }
    }
    stage('plan') {
        steps {
            sh 'echo This is test'
        }
    }
    stage('Deploy') {
        steps {
            sh 'echo This is Deploy'
        }
    }
 }
 post {
    always {
        echo 'I will always say Hello again!'
    }
    success {
        echo 'I will run when pipeline is success'
    }
    failure {
        echo 'I will run when pipeline is failure'
    }
 }
}