#!groovy

node {
  def project = 'flugelprod'
  def appName = 'wp-flugelit'
  def appRepo = 'https://github.com/d-averkiev/wp-composer'
  def imageTag = "us.gcr.io/${project}/${appName}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
  
  stage('Build image') {
    def imageTag = 'us.gcr.io/iconic-nimbus-197104/wp-demo'

    googleCloudBuild \
      credentialsId: 'iconic-nimbus-197104',
      request: file('cloudbuild.yaml'),
      substitutions: [
        _TAG: imageTag,
        _PROJECT_REPO: appRepo
      ]
  }
}
