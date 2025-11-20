pipeline {
    agent any

    tools {
        jdk 'JDK21'        // Must match the name in "Global Tool Configuration"
        maven 'M2_HOME'    // Must match your Maven installation name
    }

    environment {
        // Docker environment variables
        DOCKER_USERNAME = "riadh2002"
        DOCKER_IMAGE_NAME = "my-country-service"
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


        stage('Deploy with Ansible') {
            steps {
                echo '🚀 Deploying with Ansible (Docker + Kubernetes)...'
                withCredentials([string(credentialsId: 'ansible-vault-password', variable: 'VAULT_PASS')]) {
                    sh 'echo "$VAULT_PASS" | ansible-playbook -i hosts playbookCICD.yml --vault-password-file /dev/stdin'
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                echo '✅ Verifying Kubernetes deployment...'
                script {
                    sh '''
                        kubectl get deployments -n jenkins
                        kubectl get pods -n jenkins
                        kubectl get svc -n jenkins
                    '''
                }
            }
        }
        
        stage('Verify Monitoring Stack') {
            steps {
                echo '📊 Verifying Prometheus and Grafana deployment...'
                script {
                    sh '''
                        echo "=== Prometheus Status ==="
                        kubectl get deployment prometheus-deployment -n jenkins
                        kubectl get svc prometheus-service -n jenkins
                        
                        echo "=== Grafana Status ==="
                        kubectl get deployment grafana-deployment -n jenkins
                        kubectl get svc grafana-service -n jenkins
                        
                        echo "=== Getting NodePort URLs ==="
                        PROMETHEUS_PORT=$(kubectl get svc prometheus-service -n jenkins -o jsonpath='{.spec.ports[0].nodePort}')
                        GRAFANA_PORT=$(kubectl get svc grafana-service -n jenkins -o jsonpath='{.spec.ports[0].nodePort}')
                        NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
                        
                        echo "📊 Prometheus URL: http://$NODE_IP:$PROMETHEUS_PORT"
                        echo "📈 Grafana URL: http://$NODE_IP:$GRAFANA_PORT"
                        echo "Grafana Credentials - Username: admin, Password: admin123"
                    '''
                }
            }
        }
    }

    post {
        always {
            echo '✅ Pipeline completed!'
            cleanWs()
        }
        success {
            echo '🎉 Build, Test, Package, Docker Build/Push, and Deployment succeeded!'
        }
        failure {
            echo '❌ Pipeline failed. Check console logs for details.'
        }
    }
}
