#!/bin/bash

FROM_IMAGE="debian"
FROM_TAG="10.7-slim"

IMAGE_NAME="900253156012.dkr.ecr.us-east-2.amazonaws.com/baseimage"


#
# make sure the base is current
#
docker pull ${FROM_IMAGE}:${FROM_TAG}

# build the new image
docker build \
  --build-arg=FROM_IMAGE=$FROM_IMAGE \
  --build-arg=FROM_TAG=$FROM_TAG \
  -t $IMAGE_NAME:$FROM_TAG \
  .

#
# We don't want to push the image during local builds, only during codebuild builds.
#
if [ ! -z "${CODEBUILD_BUILD_ID}" ]; then

  echo $(aws ecr get-login-password --region us-east-2) | docker login -u AWS --password-stdin $IMAGE_NAME

  docker push $IMAGE_NAME:$FROM_TAG
fi
