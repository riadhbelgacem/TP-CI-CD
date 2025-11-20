pipeline {
    agent any

    tools {
        jdk 'JDK21'
        maven 'M2_HOME'
    }

    environment {
        DOCKER_USERNAME = "riadh2002"
        DOCKER_IMAGE_NAME = "my-country-service"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/riadhbelgacem/TP-CI-CD.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean package'
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonarQubeServer') {
                    sh 'mvn verify sonar:sonar'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    try {
                        timeout(time: 2, unit: 'MINUTES') {
                            waitForQualityGate abortPipeline: false
                        }
                    } catch (Exception e) {
                        echo "Quality Gate check failed or timed out, but continuing build..."
                        echo "Check SonarQube dashboard manually: http://localhost:9000/dashboard?id=CountryService"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([string(credentialsId: 'ansible-vault-password', variable: 'VAULT_PASS')]) {
                    sh 'echo "$VAULT_PASS" | ansible-playbook -i hosts playbookCICD.yml --vault-password-file /dev/stdin'
                }
            }
        }

        stage('Verify') {
            parallel {
                stage('Kubernetes') {
                    steps {
                        sh 'kubectl get deployments,pods,svc -n jenkins'
                    }
                }
                stage('Monitoring') {
                    steps {
                        sh '''
                            kubectl get deployment prometheus-deployment grafana-deployment -n jenkins
                            echo "Prometheus: http://localhost:$(kubectl get svc prometheus-service -n jenkins -o jsonpath='{.spec.ports[0].nodePort}')"
                            echo "Grafana: http://localhost:$(kubectl get svc grafana-service -n jenkins -o jsonpath='{.spec.ports[0].nodePort}')"
                        '''
                    }
                }
            }
        }

        stage('Test Infrastructure') {
            steps {
                withCredentials([string(credentialsId: 'ansible-vault-password', variable: 'VAULT_PASS')]) {
                    dir('terraform') {
                        sh '''
                            export LOCALSTACK_AUTH_TOKEN=$(echo "$VAULT_PASS" | ansible-vault view ../vault.yml --vault-password-file /dev/stdin | grep localstack_auth_token | awk '{print $2}' | tr -d '"')
                            docker-compose down -v || true
                            docker-compose up -d
                            
                            for i in {1..30}; do
                                curl -s http://localhost:4566/_localstack/health | grep -q '"s3": "available"' && break
                                sleep 2
                            done
                            
                            terraform init -upgrade
                            terraform apply -auto-approve
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
