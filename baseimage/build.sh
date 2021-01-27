#!/bin/bash

FROM_IMAGE="debian"
FROM_TAG="10-slim"

#
# Supply this value for local builds, online it's provided by the codebuild project.
#
if [ -z "${CODEBUILD_BUILD_ID}" ]; then
  IMAGE_NAME=$(cd ../infra/prod && terraform output -json | jq '.war.value.ecr.baseimage.repository_url' --raw-output)
fi

#
# make sure the base is current
#
docker pull ${FROM_IMAGE}:${FROM_TAG}

# build the new image
docker build \
  --build-arg=FROM_IMAGE=$FROM_IMAGE \
  --build-arg=FROM_TAG=$FROM_TAG \
  -t $IMAGE_NAME:latest \
  .

#
# We don't want to push the image during local builds, only during codebuild builds.
#
if [ ! -z "${CODEBUILD_BUILD_ID}" ]; then

  echo $(aws ecr get-login-password --region us-east-2) | docker login -u AWS --password-stdin $IMAGE_NAME

  docker push $IMAGE_NAME:latest
fi
