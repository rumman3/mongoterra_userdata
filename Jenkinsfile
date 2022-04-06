pipeline {
  agent any

  environment {
    IMAGE_NAME = "rumman123/spartanmongopy:1." + "$BUILD_NUMBER"
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
          docker.withRegistry('','docker_hub_cred'){
            DOCKER_IMAGE.push()
          }
        }
      }
    }
  }
}
