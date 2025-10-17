pipeline {
    agent any

    tools {
        jdk 'JDK21'        // Make sure this matches the exact name in "Global Tool Configuaton"
        maven 'M2_HOME'    // Same here — must match the configured Maven name
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/riadhbelgacem/TP-CI-CD.git'
            }
        }

        stage('Compile') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
            post {
                success {
                    junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Use your globally configured SonarQube installation
                withSonarQubeEnv('MySonarQubeServer') {
                    sh 'mvn -B verify sonar:sonar'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished!'
        }
    }
}
