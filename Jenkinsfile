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
    imageTag = "us.gcr.io/${project}/${appName}:${env.BUILD_NUMBER}"

    googleCloudBuild \
      credentialsId: project,
      request: file('cloudbuild.yml'),
      substitutions: [
        _TAG: imageTag,
        _PROJECT_REPO: appRepo
      ]
  }
  
  stage('Deploy Application') {
    sh("sed -i.bak 's#us.gcr.io/flugelprod/wp-flugelit:0.4#us.gcr.io/flugelprod/wp-flugelit:0.6#' ./k8s/wp-flugelit-deployment.yml")
    sh("kubectl apply --namespace=default -f k8s/wp-flugelit-service.yml")
    sh("kubectl apply --namespace=default -f k8s/wp-flugelit-deployment.yml")
  }
}
