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
                        sh '''
                            kubectl get deployments,pods,svc -n jenkins
                        '''
                    }
                }
                stage('Monitoring') {
                    steps {
                        sh '''
                            kubectl get deployment prometheus-deployment -n jenkins
                            kubectl get deployment grafana-deployment -n jenkins
                            PROMETHEUS_PORT=$(kubectl get svc prometheus-service -n jenkins -o jsonpath='{.spec.ports[0].nodePort}')
                            GRAFANA_PORT=$(kubectl get svc grafana-service -n jenkins -o jsonpath='{.spec.ports[0].nodePort}')
                            echo "📊 Prometheus: http://localhost:$PROMETHEUS_PORT"
                            echo "📈 Grafana: http://localhost:$GRAFANA_PORT (admin/admin123)"
                        '''
                    }
                }
            }
        }

        stage('Test Infrastructure') {
            steps {
                dir('terraform') {
                    sh '''
                        docker-compose up -d
                        
                        # Wait for LocalStack
                        for i in {1..30}; do
                            curl -s http://localhost:4566/_localstack/health | grep -q '"s3": "available"' && break
                            sleep 2
                        done
                        
                        terraform init -upgrade
                        terraform validate
                        terraform apply -auto-approve
                        
                        # Test S3
                        BUCKET=$(terraform output -raw bucket_name)
                        aws --endpoint-url=http://localhost:4566 s3 ls s3://$BUCKET
                        
                        # Cleanup
                        terraform destroy -auto-approve
                        docker-compose down
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo '✅ Pipeline succeeded!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
