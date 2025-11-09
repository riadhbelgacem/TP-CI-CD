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


        stage('Setup Kubernetes Dependencies') {
            steps {
                echo '🔧 Installing Kubernetes dependencies...'
                script {
                    sh '''
                        # Install kubernetes Python library for system Python3
                        sudo pip3 install kubernetes --break-system-packages || pip3 install --user kubernetes || true
                        
                        # Install Ansible Kubernetes collection
                        ansible-galaxy collection install kubernetes.core || true
                        
                        # Verify kubectl is available
                        kubectl version --client || echo "kubectl not found, please install it"
                        
                        # Check if kubernetes cluster is accessible
                        kubectl cluster-info || echo "Warning: Cannot connect to Kubernetes cluster"
                        
                        # Verify kubernetes Python module is available
                        python3 -c "import kubernetes; print('✅ Kubernetes Python library installed')" || echo "❌ Kubernetes library not found"
                    '''
                }
            }
        }

        stage('Deploy using ansible playbook') {
            steps {
                echo '🚀 Deploying to Kubernetes with Ansible...'
                script {
                    sh '''
                        # Ensure kubernetes namespace exists
                        kubectl create namespace jenkins --dry-run=client -o yaml | kubectl apply -f - || true
                        
                        # Set environment variables for Ansible
                        export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3
                        export K8S_AUTH_VERIFY_SSL=no
                        
                        # Run ansible playbook with verbose output for debugging
                        ansible-playbook -i hosts playbookCICD.yml -v
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
