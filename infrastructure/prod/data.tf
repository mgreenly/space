#
# collect references to existing resources
#

data "aws_vpc" "default" {
  tags = {
    Name   = "default"
  }
}

data "aws_security_group" "default" {
  tags = {
    Name   = "default"
  }
}

data "aws_subnet" "a" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = "us-east-2a"
}

data "aws_subnet" "b" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = "us-east-2b"
}

data "aws_subnet" "c" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = "us-east-2c"
}


data "aws_iam_user" "mgreenly" {
  user_name = "michael.greenly"
}

data "aws_iam_policy" "ec2_container_registry_power_user" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

data "aws_iam_policy" "code_commit_power_user" {
  arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

data "aws_iam_policy" "cloud_watch_logs_full_access" {
  arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

data "aws_iam_policy" "s3_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
