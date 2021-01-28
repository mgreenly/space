#!/bin/sh

BUILDER_IMAGE="900253156012.dkr.ecr.us-east-2.amazonaws.com/builder_ghc"
BUILDER_TAG="8.10.3"

exec docker run --rm -it \
  -u $(id -u):0 \
  -v $PWD/.cabal:/root/.cabal \
  -v $PWD:/workdir  \
  -w /workdir \
  ${BUILDER_IMAGE}:${BUILDER_TAG}
