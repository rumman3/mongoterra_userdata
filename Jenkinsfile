pipeline {
  agent any

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
          docker.build 'rumman123/spartanmongopy'
        }
      }
    }
  }
}
