#
# create the role for the build instance
#
resource "aws_iam_role" "codebuild" {
  name = "codebuild"

  assume_role_policy = <<ROLE
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
ROLE
}


#
# Policies for the code build instance role
#
resource "aws_iam_role_policy_attachment" "s3_full_access_for_codebuild" {
  role = aws_iam_role.codebuild.name
  policy_arn = data.aws_iam_policy.s3_full_access.arn
  depends_on = [ aws_iam_role.codebuild
  ]
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_power_user_for_codebuild" {
  role = aws_iam_role.codebuild.name
  policy_arn = data.aws_iam_policy.ec2_container_registry_power_user.arn
  depends_on = [
      aws_iam_role.codebuild
  ]
}

resource "aws_iam_role_policy_attachment" "cloud_watch_logs_full_access_for_codebuild" {
  role = aws_iam_role.codebuild.name
  policy_arn = data.aws_iam_policy.cloud_watch_logs_full_access.arn
  depends_on = [
      aws_iam_role.codebuild
  ]
}

resource "aws_iam_role_policy_attachment" "code_commit_power_user_for_codebuild" {
  role = aws_iam_role.codebuild.name
  policy_arn = data.aws_iam_policy.code_commit_power_user.arn
  depends_on = [
      aws_iam_role.codebuild
  ]
}


#
# CODECOMMIT REPOSITORIES
#
resource "aws_codecommit_repository" "war" {
  repository_name = "war"
  description     = "This is the mono repo holding the entire war app."
}

#
# BASE IMAGE GHC
#
resource "aws_ecr_repository" "baseimage" {
  name = "baseimage"
}

resource "aws_codebuild_project" "baseimage" {
  name = "baseimage"
  service_role = aws_iam_role.codebuild.arn
  source_version = "refs/heads/main"
  queued_timeout = 480
  build_timeout  = 60

  artifacts {
    encryption_disabled    = false
    override_artifact_name = false
    type                   = "NO_ARTIFACTS"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_LARGE"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
      buildspec           = "baseimage/buildspec.yml"
      git_clone_depth     = 1
      insecure_ssl        = false
      location            = aws_codecommit_repository.war.clone_url_http
      report_build_status = false
      type                = "CODECOMMIT"

      git_submodules_config {
          fetch_submodules = false
      }
  }

  depends_on = [
      aws_iam_role.codebuild
  ]
}


#
# BUILDER GHC
#
resource "aws_ecr_repository" "builder_ghc" {
  name = "builder_ghc"
}



resource "aws_codebuild_project" "builder_ghc" {
  name = "builder_ghc"
  service_role = aws_iam_role.codebuild.arn
  source_version = "refs/heads/main"
  queued_timeout = 480
  build_timeout  = 60

  artifacts {
    encryption_disabled    = false
    override_artifact_name = false
    type                   = "NO_ARTIFACTS"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_LARGE"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
      buildspec           = "builder-ghc/buildspec.yml"
      git_clone_depth     = 1
      insecure_ssl        = false
      location            = aws_codecommit_repository.war.clone_url_http
      report_build_status = false
      type                = "CODECOMMIT"

      git_submodules_config {
          fetch_submodules = false
      }
  }

  depends_on = [
      aws_iam_role.codebuild
  ]
}












# resource "aws_codecommit_repository" "war" {
#   repository_name = "war"
#   description     = "The war ci/cd repo"
# }

# resource "aws_ecr_repository" "war_app" {
#   name = "war_app"
# }


# resource "aws_codebuild_project" "war_app" {
#   name = "war_app"
#   service_role = aws_iam_role.war_codebuild.arn
#   source_version = "refs/heads/main"
#   queued_timeout = 480
#   build_timeout  = 60

#   artifacts {
#     encryption_disabled    = false
#     override_artifact_name = false
#     type                   = "NO_ARTIFACTS"
#   }

#   cache {
#     modes = []
#     type  = "NO_CACHE"
#   }

#   environment {
#     compute_type                = "BUILD_GENERAL1_LARGE"
#     image                       = "aws/codebuild/standard:4.0"
#     image_pull_credentials_type = "CODEBUILD"
#     privileged_mode             = true
#     type                        = "LINUX_CONTAINER"

#     environment_variable {
#       name  = "IMAGE_NAME"
#       value = aws_ecr_repository.war_app.repository_url
#     }
#   }

#   logs_config {
#     cloudwatch_logs {
#       status = "ENABLED"
#     }

#     s3_logs {
#       encryption_disabled = false
#       status              = "DISABLED"
#     }
#   }

#   source {
#       buildspec           = "codebuild/haskell/buildspec.yml"
#       git_clone_depth     = 1
#       insecure_ssl        = false
#       location            = aws_codecommit_repository.war.clone_url_http
#       report_build_status = false
#       type                = "CODECOMMIT"

#       git_submodules_config {
#           fetch_submodules = false
#       }
#   }

#   depends_on = [
#       aws_iam_role.war_codebuild
#   ]
# }

# resource "aws_ecr_repository" "war_api" {
#   name = "war_api"
# }


# resource "aws_s3_bucket" "war" {
#   bucket = "war.logic-refinery.io"
#   acl    = "private"

#   # tags = {
#   #   Name        = "My bucket"
#   #   Environment = "Dev"
#   # }
# }

# resource "aws_codebuild_project" "war_api" {
#     badge_enabled  = false
#     build_timeout  = 10
#     description    = "The actual api"
#     name           = "war_api"
#     queued_timeout = 60
#     service_role = aws_iam_role.war_codebuild.arn
#     source_version = "refs/heads/main"
#     tags           = {}

#     artifacts {
#         encryption_disabled    = false
#         override_artifact_name = false
#         type                   = "NO_ARTIFACTS"
#     }

#     cache {
#         type     = "S3"
#         location = "${aws_s3_bucket.war.bucket}/codebuild/cache/war"
#         modes = []
#     }

#     environment {
#       compute_type                = "BUILD_GENERAL1_LARGE"
#       image                       = "aws/codebuild/standard:4.0"
#       image_pull_credentials_type = "CODEBUILD"
#       privileged_mode             = true
#       type                        = "LINUX_CONTAINER"

#       environment_variable {
#         name  = "BUILDER_IMAGE"
#         value = aws_ecr_repository.war_app.repository_url
#       }

#       environment_variable {
#         name  = "IMAGE_NAME"
#         value = aws_ecr_repository.war_api.repository_url
#       }
#     }

#     logs_config {
#         cloudwatch_logs {
#             status = "ENABLED"
#         }

#         s3_logs {
#             encryption_disabled = false
#             status              = "DISABLED"
#         }
#     }

#     source {
#         buildspec           = "api/buildspec.yml"
#         git_clone_depth     = 1
#         insecure_ssl        = false
#         location            = aws_codecommit_repository.war.clone_url_http
#         report_build_status = false
#         type                = "CODECOMMIT"

#         git_submodules_config {
#             fetch_submodules = false
#         }
#    }

#   depends_on = [
#       aws_iam_role.war_codebuild
#   ]
# }
