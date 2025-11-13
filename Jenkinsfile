pipeline {
    agent any
    
    environment {
        APP_NAME = 'demo-app'
        APP_VERSION = "${env.BUILD_NUMBER}"
        DOCKER_IMAGE = "${APP_NAME}:${APP_VERSION}"
        DOCKER_IMAGE_LATEST = "${APP_NAME}:latest"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh '''
                    python3 --version
                    export PATH=$PATH:/usr/local/bin:/usr/bin
                    python3 -m pip install --user -r requirements.txt
                '''
            }
        }
        
        stage('Test') {
            steps {
                sh '''
                    export PATH=$PATH:/root/.local/bin
                    cd /var/jenkins_home/workspace/api_avengers
                    python3 -m unittest app.test_app -v
                '''
            }
        }
        
        stage('Package') {
            steps {
                sh '''
                    export PATH=$PATH:/usr/bin
                    docker build -t ${DOCKER_IMAGE} -t ${DOCKER_IMAGE_LATEST} .
                    docker images | grep ${APP_NAME}
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                sh '''
                    export PATH=$PATH:/usr/bin
                    docker compose version || docker-compose version || true
                    docker compose down || docker-compose down || true
                    docker compose up -d || docker-compose up -d
                    sleep 5
                    docker compose ps || docker-compose ps
                '''
            }
        }
        
        stage('Health Check') {
            steps {
                sh '''
                    export PATH=$PATH:/usr/bin
                    docker ps | grep ${APP_NAME} || docker compose ps || docker-compose ps
                    chmod +x healthcheck.sh
                    ./healthcheck.sh || true
                    curl -f http://localhost:5000/ || exit 1
                    curl -f http://localhost:5000/health || exit 1
                '''
            }
        }
    }
    
    post {
        success {
            echo "Pipeline completed! App running at http://localhost:5000"
        }
        failure {
            sh 'export PATH=$PATH:/usr/bin; docker compose down || docker-compose down || true'
        }
    }
}

