#!/bin/bash


#
# When we're running locally we need to define these values.  When we're
# running in codebuilder the buildspec.yaml will define these.
#
if [ -z "${CODEBUILD_BUILD_ID}" ]; then
  FROM_IMAGE="debian"
  FROM_TAG="10-slim"
  GHC_VER="8.10.3"
  CABAL_VER="3.2.0.0"
  IMAGE_NAME=$(cd ../infra/prod && terraform output -json | jq '.war.value.ecr.ghc_builder.repository_url' --raw-output)
  AWS_PROFILE="logic-refinery"
fi

#
# make sure the base is current
#
docker pull ${FROM_IMAGE}:${FROM_TAG}

# build the new image
docker build \
  --build-arg FROM_IMAGE=$FROM_IMAGE \
  --build-arg FROM_TAG=$FROM_TAG \
  --build-arg GHC_VER=$GHC_VER \
  --build-arg CABAL_VER=$CABAL_VER \
  -t $IMAGE_NAME:$GHC_VER \
  .

#
# push the image if we're not running locally
#
if [ ! -z "${CODEBUILD_BUILD_ID}" ]; then

  echo $(aws --profile $AWS_PROFILE ecr get-login-password --region us-east-2) | docker login -u AWS --password-stdin $IMAGE_NAME

  docker push $IMAGE_NAME:$GHC_VER
fi
