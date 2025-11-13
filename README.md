# CI/CD Pipeline Demo

Simple Flask app with Jenkins pipeline that builds, tests, packages, and deploys using Docker.

## Quick Start

**Run locally:**
```bash
docker-compose up -d
curl http://localhost:5000/
curl http://localhost:5000/health
./healthcheck.sh
```

**Run tests:**
```bash
pip install -r requirements.txt
python -m unittest app.test_app -v
```

## Jenkins Setup

**Option 1: Existing Jenkins**
1. Create Pipeline job
2. Point to this repo
3. Set script path to `Jenkinsfile`
4. Run

**Option 2: Docker Jenkins (Docker-in-Docker)**
```bash
docker-compose -f docker-compose.jenkins.yml up -d
# Access http://localhost:8080
# Get password: docker exec jenkins-docker cat /var/jenkins_home/secrets/initialAdminPassword
# Create Pipeline job pointing to Jenkinsfile
```

## Pipeline Stages

1. Checkout - Get code
2. Build - Install deps
3. Test - Run unit tests
4. Package - Build Docker image
5. Deploy - Start with docker-compose
6. Health Check - Verify endpoints

## Files

- `app/app.py` - Flask app with / and /health
- `app/test_app.py` - Unit tests
- `Dockerfile` - Container build
- `docker-compose.yml` - App deployment
- `docker-compose.jenkins.yml` - Jenkins setup
- `Jenkinsfile` - Pipeline definition
- `healthcheck.sh` - Health verification

## Ports

- App: http://localhost:5000
- Jenkins: http://localhost:8080
