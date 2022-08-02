#!/usr/bin/env groovy

dockerRegistryDomain = '979633842206.dkr.ecr.eu-west-1.amazonaws.com'
dockerRegistryUrl = "https://${dockerRegistryDomain}"
ecrCredentialId = 'ecr:eu-west-1:cita-devops'

ecrRepoName = "postcoder"

node("docker && awsaccess"){
  checkout scm

  stage("build") {
    dockerImage = docker.build("${ecrRepoName}:${env.BUILD_TAG}")
  }

  stage("lint"){
    sh "docker-compose run -e POSTCODER_VERSION_TAG=:${env.BUILD_TAG} --rm app bundle exec rubocop"
  }

  stage("test"){
    sh "docker-compose run -e POSTCODER_VERSION_TAG=:${env.BUILD_TAG} -e APP_ENV=test --rm app bundle exec rspec"
  }

  stage("push"){
    docker.withRegistry(dockerRegistryUrl, ecrCredentialId) {
      image_tag = false
      if (env.BRANCH_NAME == "main") {
        image_tag = "latest"
      }
      if (env.CHANGE_BRANCH ==~ /^v\d+((.\d+){0,2}(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?)?$/) {
        image_tag = env.CHANGE_BRANCH
      }
      if (image_tag) {
        echo "pushing to registry ${ecrRepoName}:${image_tag}"
        sh "docker buildx create --use"
        sh "docker buildx build --push --tag='${dockerRegistryDomain}/${ecrRepoName}:${image_tag}' --platform=linux/amd64,linux/arm64 ."
      }
    }
  }
}
