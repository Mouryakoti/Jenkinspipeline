pipeline {
    agent any
     tools {
         maven "mymaven"
     }
    stages {
        stage('code') {
            steps {
                git 'https://github.com/Mouryakoti/one.git'
            }
        }
        stage('build') {
            steps {
               sh "mvn clean package"
            }
        }
        stage('artifact') {
            steps {
                nexusArtifactUploader artifacts: [[artifactId: 'myweb', classifier: '', file: 'target/myweb-8.7.0.war', type: 'war']], credentialsId: 'nexus', groupId: 'in.javahome', nexusUrl: '13.60.240.14:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'flm-repo', version: '8.7.0'
            }
        }
       stage('deploy') {
            steps {
              deploy adapters: [tomcat9(alternativeDeploymentContext: '', credentialsId: 'token', path: '', url: 'http://13.60.213.212:8080/')], contextPath: 'nexus', war: 'target/*.war'
             }
        }
    }    
}    
