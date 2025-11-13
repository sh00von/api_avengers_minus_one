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
                    pip3 install -r requirements.txt || pip install -r requirements.txt
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
                    docker-compose down || true
                    docker-compose up -d
                    sleep 5
                    docker-compose ps
                '''
            }
        }
        
        stage('Health Check') {
            steps {
                sh '''
                    docker ps | grep ${APP_NAME} || docker-compose ps
                    chmod +x healthcheck.sh
                    ./healthcheck.sh
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
            sh 'docker-compose down || true'
        }
    }
}

