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
                    python3 -m pip install --break-system-packages -r requirements.txt
                '''
            }
        }
        
        stage('Test') {
            steps {
                sh '''
                    cd /var/jenkins_home/workspace/api_avengers
                    python3 -m unittest app.test_app -v
                '''
            }
        }
        
        stage('Package') {
            steps {
                sh '''
                    chmod 666 /var/run/docker.sock 2>/dev/null || true
                    chown root:docker /var/run/docker.sock 2>/dev/null || true
                    chmod +x /usr/bin/docker 2>/dev/null || true
                    which docker || find /usr -name docker -type f 2>/dev/null | head -1
                    docker build -t ${DOCKER_IMAGE} -t ${DOCKER_IMAGE_LATEST} .
                    docker images | grep ${APP_NAME}
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                sh '''
                    chmod 666 /var/run/docker.sock 2>/dev/null || true
                    chown root:docker /var/run/docker.sock 2>/dev/null || true
                    chmod +x /usr/bin/docker 2>/dev/null || true
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
                    chmod 666 /var/run/docker.sock 2>/dev/null || true
                    chown root:docker /var/run/docker.sock 2>/dev/null || true
                    chmod +x /usr/bin/docker 2>/dev/null || true
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

