#
# The state for this plan is saved in S3 and that requires
# the S3 bucket and the DynamoDB table that manages the lock
# already exists.
#
# Those resources could be be created by hand or better yet be
# managed by another higher layer of terraform that sits above
# the scope of this infrastructure
#
# Just know these two things must already exist, we just import
# references to them here.
#

provider "aws" {
  region = "us-east-2"
  profile = "logic-refinery"
}

data "aws_s3_bucket" "terraform" {
  bucket = "terraform.logic-refinery.io"
}

data "aws_dynamodb_table" "terraform" {
  name  = "war.logic-refinery.io"
}

terraform {
  backend "s3" {
    profile = "logic-refinery"
    bucket         = "terraform.logic-refinery.io"
    key            = "state/war"
    region         = "us-east-2"
    dynamodb_table = "war.logic-refinery.io"
    encrypt        = true
  }
}
