#!/bin/bash

GHC_VER="8.10.3"
CABAL_VER="3.2.0.0"
FROM_TAG="10.7-slim"
FROM_IMAGE="900253156012.dkr.ecr.us-east-2.amazonaws.com/baseimage"
IMAGE_NAME="900253156012.dkr.ecr.us-east-2.amazonaws.com/builder_ghc"

if [ -z "${CODEBUILD_BUILD_ID}" ]; then
  echo $(aws --profile=logic-refinery ecr get-login-password --region us-east-2) | docker login -u AWS --password-stdin $IMAGE_NAME
else
  echo $(aws ecr get-login-password --region us-east-2) | docker login -u AWS --password-stdin $IMAGE_NAME
fi

#
# make sure the base is current
#
docker pull ${FROM_IMAGE}:${FROM_TAG}

# build the new image
docker build \
  --build-arg=FROM_IMAGE=$FROM_IMAGE \
  --build-arg=FROM_TAG=$FROM_TAG \
  --build-arg=GHC_VER=$GHC_VER \
  --build-arg=CABAL_VER=$CABAL_VER \
  -t $IMAGE_NAME:$GHC_VER \
  .

#
# We don't want to push the image during local builds, only during codebuild builds.
#
if [ ! -z "${CODEBUILD_BUILD_ID}" ]; then
  docker push $IMAGE_NAME:$GHC_VER
fi
