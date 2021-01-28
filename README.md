# war

A poorly choosen name that will change in the near future.

## TLDR

This is a hobby software project that combines a bunch of the things I enjoy into one thing.

More to come later...

### backend

  The applications backend.  A haskell application that handles the websocket connections from the frontend.

### baseimage

  The base docker image used for all other images.

### builder-elm

  A docker image that provides the elm toolchain to assemble the frontend.

### builder-ghc

  A docker image that provides the ghc toolchain to assemble the backend.

### deployment

  The kubernetes config files.

### frontend

  The applications frontend.  A elm application and all static assets.

### infrastructure

  The terraform files used to manage the infrastructure.


## Tools

  * aws       - https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
  * docker    - https://docs.docker.com/engine/install/debian/#install-using-the-repository
  * kubectl   - https://kubernetes.io/docs/tasks/tools/install-kubectl/
  * terraform - https://learn.hashicorp.com/tutorials/terraform/install-cli
  * jq        - https://stedolan.github.io/jq/
