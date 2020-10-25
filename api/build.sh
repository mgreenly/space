#!/bin/bash

BUILDER_IMAGE="900253156012.dkr.ecr.us-east-2.amazonaws.com/codebuild_haskell"
BUILDER_TAG="latest"

FROM_IMAGE="debian"
FROM_TAG="10-slim"


#
# Automation to build and upload this docker image. 
#
echo $(aws ecr get-login-password --region us-east-2) | docker login -u AWS --password-stdin 900253156012.dkr.ecr.us-east-2.amazonaws.com/codebuild_haskell

docker pull ${BUILDER_IMAGE}:${BUILDER_TAG}


#
# the provided arguments are passed to the container
#
docker run --rm -i -t \
  -u $(id -u):$(id -g) \
  -v $PWD/.debian-cabal:/home/haskell/.cabal \
  -v $PWD:/workdir  \
  -w /workdir \
  ${BUILDER_IMAGE}:${BUILDER_TAG} \
  cabal build


mkdir -p files/usr/local/bin

find dist-newstyle/ -executable -type f ! -name '*.so' -exec cp {} files/usr/local/bin \;

# IMAGE_NAME="900253156012.dkr.ecr.us-east-2.amazonaws.com/war_api"

docker build \
  --build-arg FROM_IMAGE=$FROM_IMAGE \
  --build-arg FROM_TAG=$FROM_TAG \
  --build-arg GHC_VER=$GHC_VER \
  --build-arg CABAL_VER=$CABAL_VER \
  -t $IMAGE_NAME:latest \
  .

echo $(aws ecr get-login-password --region us-east-2) | docker login -u AWS --password-stdin $IMAGE_NAME

docker push $IMAGE_NAME:latest
