####################################################################################################
### LOCAL VARIABLES / DATAS

locals {
  global_tags = {
    org             = var.org
    scope           = var.scope
    platform_region = var.platform_region
    environment     = var.environment
    service         = var.service
    deployed_by     = var.deployed_by
    workspace       = terraform.workspace
    critical        = var.critical
    terraform       = "true"
  }
}

####################################################################################################
### STATES S3 BUCKET

resource "aws_s3_bucket" "terraform_states" {
  bucket = "${var.global_prefix}-${var.environment}-terrstates"

  # Enable versioning so we can see the full revision history of our
  # state files
  # versioning {
  #   enabled = true
  # }

  lifecycle {
    prevent_destroy = true
  }

  tags = local.global_tags
  # # Enable server-side encryption by default
  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "AES256"
  #     }
  #   }
  # }
}

resource "aws_s3_bucket_versioning" "terraform_states_versioning" {
  bucket = aws_s3_bucket.terraform_states.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_states_encryption" {
  bucket = aws_s3_bucket.terraform_states.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_states_block_public_acl" {
  bucket = aws_s3_bucket.terraform_states.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "terraform_states_acl" {
  bucket = aws_s3_bucket.terraform_states.id
  acl    = "private"
}

####################################################################################################
### DYNAMODB TABLE

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.global_prefix}-${var.environment}-terrlocks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.global_tags
}
