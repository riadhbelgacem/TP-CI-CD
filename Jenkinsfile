pipeline {
    agent any

    tools {
        jdk 'JDK21'        // Must match the name in "Global Tool Configuration"
        maven 'M2_HOME'    // Must match your Maven installation name
    }

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/riadhbelgacem/TP-CI-CD.git'
            }
        }

        stage('Build & Test') {
            steps {
                echo 'Compiling source code and running tests...'
                sh 'mvn -B -U clean verify'
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube') {
            steps {
                echo 'Running SonarQube code analysis...'
                withSonarQubeEnv('MySonarQubeServer') {
                    sh 'mvn -B sonar:sonar'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                echo 'Waiting for SonarQube quality gate...'
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Deploy to Nexus') {
            steps {
                echo 'Deploying to Nexus Repository Manager...'
                withMaven(maven: 'M2_HOME', mavenSettingsConfig: 'NEXUS_SETTINGS_ID') {
                    sh 'mvn -B -DskipTests deploy'
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                script {
                    echo 'Deploying to Tomcat via Ansible...'
                    def files = findFiles(glob: 'target/*.?ar')
                    if (files.length == 0) {
                        error 'No artifact found in target/ to deploy'
                    }
                    sh """
                        ansible-playbook deploy/deploy-tomcat.yml \
                          --extra-vars "artifact=${files[0].path}"
                    """
                }
            }
        }

    }

    post {
        always {
            echo 'Archiving artifacts and cleaning workspace...'
            archiveArtifacts artifacts: 'target/*.{jar,war}', fingerprint: true
            cleanWs()
        }
        success {
            echo 'Build, Test, Package, Nexus Upload, and Deployment succeeded!'
        }
        failure {
            echo 'Pipeline failed. Check console logs for details.'
        }
    }
}
