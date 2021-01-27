#!/bin/bash

set -e

BUILDER_IMAGE="900253156012.dkr.ecr.us-east-2.amazonaws.com/builder_ghc"
BUILDER_TAG="8.10.3"

FROM_IMAGE="900253156012.dkr.ecr.us-east-2.amazonaws.com/baseimage"
FROM_TAG="10.7-slim"

IMAGE_NAME="900253156012.dkr.ecr.us-east-2.amazonaws.com/backend"

if [ ! -z "${CODEBUILD_BUILD_ID}" ]; then
  echo $(aws ecr get-login-password --region us-east-2) | docker login -u AWS --password-stdin $IMAGE_NAME
  docker pull ${BUILDER_IMAGE}:${BUILDER_TAG}
fi

mkdir -p .cabal

docker run --rm -t \
  -u $(id -u):$(id -g) \
  -v $PWD/.cabal:/home/haskell/.cabal \
  -v $PWD:/workdir  \
  -w /workdir \
  ${BUILDER_IMAGE}:${BUILDER_TAG} \
  cabal update

docker run --rm -t \
  -u $(id -u):$(id -g) \
  -v $PWD/.cabal:/home/haskell/.cabal \
  -v $PWD:/workdir  \
  -w /workdir \
  ${BUILDER_IMAGE}:${BUILDER_TAG} \
  cabal configure

docker run --rm -t \
  -u $(id -u):$(id -g) \
  -v $PWD/.cabal:/home/haskell/.cabal \
  -v $PWD:/workdir  \
  -w /workdir \
  ${BUILDER_IMAGE}:${BUILDER_TAG} \
  cabal build

mkdir -p files/usr/local/bin
find dist-newstyle/ -executable -type f ! -name '*.so' -exec cp {} files/usr/local/bin \;

docker build \
  --build-arg FROM_IMAGE=$FROM_IMAGE \
  --build-arg FROM_TAG=$FROM_TAG \
  --build-arg GHC_VER=$GHC_VER \
  --build-arg CABAL_VER=$CABAL_VER \
  -t $IMAGE_NAME:latest \
  .

# only push the image if we're running in codebuilder
if [ ! -z "${CODEBUILD_BUILD_ID}" ]; then
  docker push $IMAGE_NAME:latest
fi
