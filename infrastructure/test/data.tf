#
# collect references to existing resources
#

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
