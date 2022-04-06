pipeline {
  agent any

  environment {
    IMAGE_NAME = "rumman123/spartanmongopy:1." + "$BUILD_NUMBER"
    DOCKER_CREDENTIALS = "docker_hub_cred"
  }

  stages {
    stage('Cloning the project from GitHub'){
      steps {
        git branch: 'main',
        url: 'https://github.com/rumman3/mongoterra_userdata.git'
      }
    }

    stage('Building a Docker Image'){
      steps {
        script {
          DOCKER_IMAGE = docker.build IMAGE_NAME
        }
      }
    }

    stage('Push to Docker Hub'){
      steps {
        script {
          docker.withRegistry('', DOCKER_CREDENTIALS){
            DOCKER_IMAGE.push()
          }
        }
      }
    }
  }
}
