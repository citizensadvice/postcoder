#!/usr/bin/env groovy

dockerRegistryDomain = '979633842206.dkr.ecr.eu-west-1.amazonaws.com'
dockerRegistryUrl = "https://${dockerRegistryDomain}"
ecrCredentialId = 'ecr:eu-west-1:cita-devops'

integrationBranches = ['develop', 'master']
isIntegrationBranch = integrationBranches.contains(env.BRANCH_NAME)

node("docker && awsaccess"){
  checkout scm

  stage("build") {
    dockerImage = docker.build("postcoder:${env.BUILD_TAG}")
  }

  stage("lint"){
    sh "docker-compose run -e POSTCODER_VERSION_TAG=:${env.BUILD_TAG} --rm app bundle exec rubocop"
  }

  stage("test"){
    sh "docker-compose run -e POSTCODER_VERSION_TAG=:${env.BUILD_TAG} -e APP_ENV=test --rm app bundle exec rspec"
  }

  stage("push"){
    docker.withRegistry(dockerRegistryUrl, ecrCredentialId) {
      if (env.BRANCH_NAME == "main") {
        echo "pushing to registry postcoder:latest"
        dockerImage.push("latest")
      }
      if (env.CHANGE_BRANCH ==~ /^v\d+((.\d+){0,2}(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?)?$/) {
        echo "pushing to registry postcoder:${env.CHANGE_BRANCH}"
        dockerImage.push(env.CHANGE_BRANCH)
      }
    }
  }
}
