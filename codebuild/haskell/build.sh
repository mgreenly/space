#!/bin/sh

#
# Automation to build and upload this docker image.
#
FROM_IMAGE="debian"
FROM_TAG="10-slim"
GHC_VER="8.8.4"
CABAL_VER="3.2.0.0"

docker build \
  --build-arg FROM_IMAGE=$FROM_IMAGE \
  --build-arg FROM_TAG=$FROM_TAG \
  --build-arg GHC_VER=$GHC_VER \
  --build-arg CABAL_VER=$CABAL_VER \
  -t $IMAGE_NAME:latest \
  .

echo $(aws ecr get-login-password --region us-east-2) | docker login -u AWS --password-stdin $IMAGE_NAME

docker push $IMAGE_NAME:latest
