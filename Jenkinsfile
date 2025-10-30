pipeline {
    agent any

    tools {
        jdk 'JDK21'        // Must match the name in "Global Tool Configuration"
        maven 'M2_HOME'    // Must match your Maven installation name
    }

    environment {
        // Docker environment variables
        DOCKER_USERNAME = "riadh2002"
        DOCKER_IMAGE_NAME = "my-compte-service"
    }

    stages {

        stage('Checkout') {
            steps {
                echo '📥 Checking out source code...'
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

        stage('Package') {
            steps {
                echo '📦 Packaging the application...'
                sh 'mvn clean package'
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

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                script {
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ."
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo '📤 Pushing Docker image to DockerHub...'
                withCredentials([string(credentialsId: 'dockerhub-paswd', variable: 'dockerhubpwd')]) {
                    sh "docker login -u ${DOCKER_USERNAME} -p ${dockerhubpwd}"
                    sh "docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                    sh "docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo '☸️ Deploying to Kubernetes...'
                withKubeConfig([credentialsId: 'kubeconfig-file']) {
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                }
            }
        }

    }

    post {
        always {
            echo '✅ Pipeline completed!'
        }
        success {
            echo '🎉 Build, Test, Package, Docker Build/Push, and Deployment succeeded!'
        }
        failure {
            echo '❌ Pipeline failed. Check console logs for details.'
        }
    }
}

