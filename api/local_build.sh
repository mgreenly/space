#!/bin/bash
export BUILDER_IMAGE="$(cd ../infra && terraform output -json | jq --raw-output .war.value.ecr.haskell.repository_url)"
export IMAGE_NAME="$(cd ../infra && terraform output -json | jq --raw-output .war.value.ecr.api.repository_url)"
export AWS_PROFILE="logic-refinery"
./build.sh

