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
# These must already exists, we just import references to them here
#
data "aws_s3_bucket" "terraform" {
  bucket = "terraform.logic-refinery.io"
}

data "aws_dynamodb_table" "terraform" {
  name  = "war.logic-refinery.io"
}

#
# Using the above references define the backend
#
terraform {
  backend "s3" {
    profile        = "logic-refinery"
    bucket         = "terraform.logic-refinery.io"
    key            = "state/war"
    region         = "us-east-2"
    dynamodb_table = "war.logic-refinery.io"
    encrypt        = true
  }
}
