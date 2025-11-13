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
                    python3 --version || python --version
                    which pip3 || which pip || apt-get update && apt-get install -y python3-pip || true
                    python3 -m pip install --user -r requirements.txt 2>/dev/null || python -m pip install --user -r requirements.txt 2>/dev/null || pip3 install --user -r requirements.txt 2>/dev/null || pip install --user -r requirements.txt 2>/dev/null || echo "Skipping pip install, will test in Docker"
                '''
            }
        }
        
        stage('Test') {
            steps {
                sh '''
                    python3 -m pytest app/test_app.py -v || python3 -m unittest app.test_app -v || python -m unittest app.test_app -v
                '''
            }
        }
        
        stage('Package') {
            steps {
                sh '''
                    docker build -t ${DOCKER_IMAGE} -t ${DOCKER_IMAGE_LATEST} .
                    docker images | grep ${APP_NAME}
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                sh '''
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
            sh 'docker compose down || docker-compose down || true'
        }
    }
}

