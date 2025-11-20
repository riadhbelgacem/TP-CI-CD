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
                        # Stop any existing LocalStack container
                        docker-compose down -v || true
                        docker rm -f localstack-countryservice || true
                        
                        # Start LocalStack
                        docker-compose up -d
                        
                        # Wait for LocalStack to be ready
                        echo "Waiting for LocalStack..."
                        attempt=0
                        max_attempts=30
                        
                        while [ $attempt -lt $max_attempts ]; do
                            if curl -s http://localhost:4566/_localstack/health | grep -q '"s3": "available"'; then
                                echo "✅ LocalStack is ready!"
                                sleep 5  # Extra wait to ensure it's fully initialized
                                break
                            fi
                            attempt=$((attempt + 1))
                            echo "Attempt $attempt/$max_attempts..."
                            sleep 2
                        done
                        
                        if [ $attempt -eq $max_attempts ]; then
                            echo "❌ LocalStack failed to start"
                            docker-compose logs localstack
                            exit 1
                        fi
                        
                        terraform init -upgrade
                        terraform validate
                        terraform apply -auto-approve
                        
                        # Test S3
                        BUCKET=$(terraform output -raw bucket_name)
                        aws --endpoint-url=http://localhost:4566 s3 ls s3://$BUCKET
                        
                        # Cleanup
                        terraform destroy -auto-approve
                        docker-compose down -v
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
