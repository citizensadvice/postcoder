#!/usr/bin/env groovy

dockerRegistryDomain = '979633842206.dkr.ecr.eu-west-1.amazonaws.com'
dockerRegistryUrl = "https://${dockerRegistryDomain}"
ecrCredentialId = 'ecr:eu-west-1:cita-devops'

integrationBranches = ['develop', 'master']
isIntegrationBranch = integrationBranches.contains(env.BRANCH_NAME)

node("docker && awsaccess"){
  checkout scm

  stage("build") {
    dockerImage = docker.build("citizensadvice/postcoder:${env.BUILD_TAG}")
  }

  stage("lint"){
    sh "docker-compose run -e POSTCODER_VERSION_TAG=:${env.BUILD_TAG} --rm app bundle exec rubocop"
  }

  stage("test"){
    sh "docker-compose run -e POSTCODER_VERSION_TAG=:${env.BUILD_TAG} -e APP_ENV=test --rm app bundle exec rspec"
  }

  stage("push"){
    if(isIntegrationBranch) {
      def dockerTag = "postcoder:${env.BUILD_TAG}"
      sh "docker tag citizensadvice/postcoder:${env.BUILD_TAG} ${dockerTag}"
      dockerImage = docker.image(dockerTag)
      docker.withRegistry(dockerRegistryUrl, ecrCredentialId) {
        dockerImage.push()
      }
    }
  }
}
