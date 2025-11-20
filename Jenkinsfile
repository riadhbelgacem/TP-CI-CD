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
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        mvn sonar:sonar \
                          -Dsonar.projectKey=CountryService \
                          -Dsonar.projectName='Country Service' \
                          -Dsonar.java.binaries=target/classes
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
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
