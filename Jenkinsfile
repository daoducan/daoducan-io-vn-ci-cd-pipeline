pipeline {
    agent {
        label "jenkins-agent"
    }
    tools {
        jdk 'java17'
        maven 'Maven3'
    }
    environment {
        APP_NAME = "daoducan-io-vn-ci-cd-pipeline"
        RELEASE = "1.0.0"
        DOCKER_USER = "daoducan88"
        DOCKER_PASS = "dockerhub"
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}" + "." + "${BUILD_NUMBER}"
        JENKINS_API_TOKEN = credentials('JENKINS_API_TOKEN')
    }

    stages {
        stage("Cleanup Workspace") {
            steps {
                cleanWs()
            }
        }

        stage("Checkout from SCM") {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/daoducan/daoducan-io-vn-ci-cd-pipeline'
            }
        }

        stage("Build & Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('', DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                    docker.withRegistry('', DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }
        }

        stage("Trigger CD Pipeline") {
            steps {
                script {
                    sh "curl -v -k --user daoducan:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'https://jenkins1.daoducan.io.vn/job/gitops-daoducan-io-vn-ci-cd-pipeline/buildWithParameters?token=gitops-token'"
                }
            }
        }
    }
}