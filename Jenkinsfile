pipeline {
    agent any

    tools {
        jdk 'JDK21'        // Must match the name in "Global Tool Configuration"
        maven 'M2_HOME'    // Must match your Maven installation name
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/riadhbelgacem/TP-CI-CD.git'
            }
        }

        stage('Compile') {
            steps {
                echo '🔧 Compiling source code...'
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                echo '🧪 Running unit tests...'
                sh 'mvn test'
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo '📊 Running SonarQube code analysis...'
                withSonarQubeEnv('MySonarQubeServer') {
                    sh 'mvn verify sonar:sonar'
                }
            }
        }
    }

    post {
        always {
            echo '✅ Pipeline completed!'
        }
        success {
            echo '🎉 Build, Test, and SonarQube Analysis succeeded!'
        }
        failure {
            echo '❌ Pipeline failed. Check console logs for details.'
        }
    }
}
