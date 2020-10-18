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

