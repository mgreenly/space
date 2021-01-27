#!/bin/bash

FROM_IMAGE="debian"
FROM_TAG="10-slim"
GHC_VER="8.10.3"
CABAL_VER="3.2.0.0"


#
# Supply this value for local builds, online it's provided by the codebuild project.
#
if [ -z "${CODEBUILD_BUILD_ID}" ]; then
  IMAGE_NAME=$(cd ../infra/prod && terraform output -json | jq '.war.value.ecr.ghc_builder.repository_url' --raw-output)
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

  echo $(aws ecr get-login-password --region us-east-2) | docker login -u AWS --password-stdin $IMAGE_NAME

  docker push $IMAGE_NAME:$GHC_VER
fi
