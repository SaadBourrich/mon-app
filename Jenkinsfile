pipeline {
    agent any
    triggers { githubPush() }
    environment {
        GITHUB_REPO  = 'git@github.com:SaadBourrich/mon-app.git'
        APP_NAME     = 'mon-app'
        GITHUB_USER  = 'Jenkins CI'
        GITHUB_EMAIL = 'jenkins@ci.local'
        SSH_CRED_ID  = 'github-ssh-key'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t mon-app:latest .'
            }
        }
        stage('Install') {
            steps {
                sh 'docker run --rm -v "${WORKSPACE}:/app" -w /app mon-app:latest npm ci'
            }
        }
        stage('Export HTML Static') {
            steps {
                sh 'docker run --rm -v "${WORKSPACE}:/app" -w /app -e NEXT_PUBLIC_BASE_PATH=/${APP_NAME} mon-app:latest npm run build'
            }
        }
        stage('Deploy GitHub Pages') {
            steps {
                sshagent(credentials: [SSH_CRED_ID]) {
                    sh '''
                        cd out
                        touch .nojekyll
                        git init
                        git checkout -b gh-pages
                        git config user.email "${GITHUB_EMAIL}"
                        git config user.name "${GITHUB_USER}"
                        git add .
                        git commit -m "deploy: $(date)"
                        git push -f ${GITHUB_REPO} HEAD:gh-pages
                    '''
                }
            }
        }
    }
    post {
        success {
            echo "Deployed to https://saadbourrich.github.io/mon-app/"
        }
        failure {
            echo "Pipeline failed"
        }
    }
}