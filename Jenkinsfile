#!groovy

node {
  def project = 'flugelprod'
  def appName = 'wp-flugelit'
  def appRepo = 'https://github.com/d-averkiev/wp-composer'
  def imageTag = "us.gcr.io/${project}/${appName}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
  
  stage('Checkout source') {
    git changelog: false, poll: false, url: "${appRepo}"
  }

  stage('Build-Push Docker Image') {
    googleCloudBuild \
      request: file('cloudbuild.yml'),
      credentialsId: "${project}", 
      substitutions: [
        _TAG: "${imageTag}",
        _PROJECT_REPO: "${appRepo}"
      ]
  }
}
