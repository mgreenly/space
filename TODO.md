# TODO

  terraform
  baseimages             - dir of base images
    debian10
  builders               - dir of builders
    ghc
    elm
  backend                - the haskell backend
  frontend               - the elm frontend










In theory this will become a roughly stack ranked list of stuff that needs doing.


* terraform the codebuild projects for both haskell and api
* the role that the codebuild uses needs access to the ecr for both
* update the build scripts so they're not hardcoded with urls

* improve the root readme
* figure out ci/cd plan
    * what docker repository to use
      * aws container registry
      * run my own
      * docker hub
    * what build pipeline
      * aws code builder
      * jenkins
      * gitlab
* build a simple haskell wai app use docker hub for now
* figure out what I need to do to redirect http traffic back to https
* sort out cli deploy
    * for now don't support deploy from jenkins


https://medium.com/swlh/intro-to-aws-codecommit-codepipeline-and-codebuild-with-terraform-179f4310fe07
