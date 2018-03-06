#!groovy

node {
  def project = 'flugelprod'
  def appName = 'wp-flugelit'
  def appRepo = 'https://github.com/d-averkiev/wp-composer'
  def imageTag = "us.gcr.io/${project}/${appName}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
  
  stage('Checkout source') {
    git changelog: false, poll: false, url: "${appRepo}"
  }

  stage('Build image') {
    sh("docker build -t ${imageTag} .")
  }

  stage('Push image to registry') {
    sh("gcloud docker -- push ${imageTag}")
  }
}
