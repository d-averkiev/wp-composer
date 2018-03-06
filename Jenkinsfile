#!groovy

node {
  def project = 'flugelprod'
  def appName = 'wp-flugelit'
  def appRepo = 'https://github.com/d-averkiev/wp-composer'
  def imageTag = ''

  stage('Checkout sources') {
    checkout scm
  }
  
  stage('Build image') {
    project = 'iconic-nimbus-197104'
    imageTag = "us.gcr.io/${project}/${appName}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"

    googleCloudBuild \
      credentialsId: project,
      request: file('cloudbuild.yml'),
      substitutions: [
        _TAG: imageTag,
        _PROJECT_REPO: appRepo
      ]
  }
}
