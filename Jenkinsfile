pipeline {
  agent any

  environment {
    IMAGE_NAME = "rumman123/spartanmongopy:1." + "$BUILD_NUMBER"
    DOCKER_CREDENTIALS = "docker_hub_cred"
  }

  stages {
    stage('Cloning the project from GitHub'){
      steps {
        checkout([
            $class: 'GitSCM', branches: [[name: '*/main']],
            UserRemoteConfigs: [[
              url: 'git@github.com:rumman3/mongoterra_userdata.git',
              credentialsId: 'ssh_git_cred'
            ]]
          ])
      }
    }

    stage('Building a Docker Image'){
      steps {
        script {
          DOCKER_IMAGE = docker.build IMAGE_NAME
        }
      }
    }

    stage('Testing the Calc Code'){
      steps{
        script {
          sh '''
            docker run --rm -v $PWD/test-results:/reports --workdir /app $IMAGE_NAME pytest -v --junitxml=/reports/results.xml
          '''
        }
      }

      post {
        always {
          junit testResults: '**/test-results/*.xml'
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

    stage ('Removing the Docker Image'){
      steps {
        sh "docker rmi $IMAGE_NAME"
      }
    }
  }
}
