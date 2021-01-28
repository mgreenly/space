#
# The state for this plan is saved in S3 and that requires
# the S3 bucket and the DynamoDB table that manages the lock
# already exists.
#
# Those resources are managed by a higher layer of terraform
# that sits above the scope of this infrastructure.
#

provider "aws" {
  region = "us-east-2"
  profile = "logic-refinery"
}

#
# Using the above references define the backend
#
terraform {
  required_version = "=0.14.5"

  backend "s3" {
    profile        = "logic-refinery"
    bucket         = "terraform.logic-refinery.io"
    key            = "state/war/prod"
    region         = "us-east-2"
    dynamodb_table = "prod.terraform.war.logic-refinery.io"
    encrypt        = true
  }
}
