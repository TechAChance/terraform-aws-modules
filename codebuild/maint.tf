data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

resource "aws_s3_bucket" "cache_bucket" {
  bucket = "${var.naming_id_prefix}-${var.project}-codebuild-cache"
  acl    = "private"
  tags   = var.global_tags
}

resource "aws_iam_role" "codebuild-role" {
  name = "${var.naming_id_prefix}-${var.project}-codebuild-role"

  assume_role_policy = <<EOF
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
EOF
  tags               = var.global_tags
}

resource "aws_iam_role_policy_attachment" "admin-attach" {
  role = aws_iam_role.codebuild-role.name

  # policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

}


resource "aws_iam_role_policy" "codebuild-policy" {
  role = aws_iam_role.codebuild-role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "${aws_s3_bucket.cache_bucket.arn}",
        "${aws_s3_bucket.cache_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:CreateReportGroup",
        "codebuild:CreateReport",
        "codebuild:UpdateReport",
        "codebuild:BatchPutTestCases",
        "codebuild:BatchPutCodeCoverages"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue"
        ],
      "Resource": [
        "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:codebuild*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters"
        ],
      "Resource": [
        "arn:aws:ssm:${local.region}:${local.account_id}:parameter/CodePipeline/*",
        "arn:aws:ssm:${local.region}:${local.account_id}:parameter/CodeBuild/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "codebuild" {
  name          = "${var.naming_id_prefix}-${var.project}-codebuild"
  description   = "Codebuild project for ${var.project}"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild-role.arn

  concurrent_build_limit = 1

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = "${aws_s3_bucket.cache_bucket.bucket}/cache"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "S3BUCKET_CACHE"
      value = aws_s3_bucket.cache_bucket.bucket
    }
    environment_variable {
      name  = "ENVIRONMENT"
      value = var.global_tags.environment
    }
    environment_variable {
      name  = "SCOPE"
      value = var.global_tags.scope
    }
    environment_variable {
      name  = "SERVICE"
      value = var.global_tags.service
    }
    # environment_variable {
    #   name  = "SOME_KEY2"
    #   value = "SOME_VALUE2"
    #   type  = "PARAMETER_STORE"
    # }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.cache_bucket.id}/build-log"
    }
  }

  source {
    type            = var.git_provider
    location        = var.git_url
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = var.git_branch

  # vpc_config {
  #   vpc_id = aws_vpc.example.id

  #   subnets = [
  #     aws_subnet.example1.id,
  #     aws_subnet.example2.id,
  #   ]

  #   security_group_ids = [
  #     aws_security_group.example1.id,
  #     aws_security_group.example2.id,
  #   ]
  # }

  tags = var.global_tags
}

resource "aws_codebuild_webhook" "codebuild_webhook" {
  project_name = aws_codebuild_project.codebuild.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "^refs/heads/${var.git_branch}$"
    }
  }
}

# resource "aws_codebuild_project" "project-with-cache" {
#   name           = "test-project-cache"
#   description    = "test_codebuild_project_cache"
#   build_timeout  = "5"
#   queued_timeout = "5"

#   service_role = aws_iam_role.example.arn

#   artifacts {
#     type = "NO_ARTIFACTS"
#   }

#   cache {
#     type  = "LOCAL"
#     modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
#   }

#   environment {
#     compute_type                = "BUILD_GENERAL1_SMALL"
#     image                       = "aws/codebuild/standard:1.0"
#     type                        = "LINUX_CONTAINER"
#     image_pull_credentials_type = "CODEBUILD"

#     environment_variable {
#       name  = "SOME_KEY1"
#       value = "SOME_VALUE1"
#     }
#   }

#   source {
#     type            = "GITHUB"
#     location        = "https://github.com/mitchellh/packer.git"
#     git_clone_depth = 1
#   }

#   tags = {
#     Environment = "Test"
#   }
# }
