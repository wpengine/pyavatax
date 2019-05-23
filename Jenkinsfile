#!groovy
@Library('wpshared') _

node ('docker') {
    wpe.pipeline('bapi-monitoring') {
        stage('Build and test') {
            sh 'make test'
        }
        stage('Create artifact') {
            sh 'make sdist'
        }
        if(env.BRANCH_NAME == 'master') {
            stage('Publish') {
                def packagePath = sh(returnStdout: true, script: 'ls dist/*.tar.gz').trim()
                gemFury.publishPackage(packagePath)
            }
        }
    }
}

