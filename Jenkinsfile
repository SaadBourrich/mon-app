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
                sh 'docker build -t mon-app:latest --build-arg NEXT_PUBLIC_BASE_PATH=/${APP_NAME} .'
            }
        }
        stage('Export HTML Static') {
            steps {
                sh '''
                    docker create --name export_tmp mon-app:latest npm run build
                    docker start -a export_tmp
                    rm -rf out
                    docker cp export_tmp:/app/out ./out
                    docker rm export_tmp
                '''
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