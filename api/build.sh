#!/bin/bash


BUILDER_TAG="latest"
FROM_IMAGE="debian"
FROM_TAG="10-slim"


#
# Automation to build and upload this docker image. 
#
echo $(aws ecr --profile logic-refinery get-login-password --region us-east-2) | docker login -u AWS --password-stdin $BUILDER_IMAGE

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

docker build \
  --build-arg FROM_IMAGE=$FROM_IMAGE \
  --build-arg FROM_TAG=$FROM_TAG \
  --build-arg GHC_VER=$GHC_VER \
  --build-arg CABAL_VER=$CABAL_VER \
  -t $IMAGE_NAME:latest \
  .

echo $(aws ecr --profile logic-refinery get-login-password --region us-east-2) | docker login -u AWS --password-stdin $IMAGE_NAME

docker push $IMAGE_NAME:latest
