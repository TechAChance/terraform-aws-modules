############
# PROVIDER #
############

provider "aws" {
  region = var.states_region
}

###########################
# LOCAL VARIABLES / DATAS #
###########################

locals {
  org_scope = ((var.org == var.scope) ? var.org : "${var.org}-${var.scope}")
  global_tags = {
    org         = var.org
    scope       = var.scope
    environment = var.environment
    service     = var.service
    deployed_by = var.deployed_by
    workspace   = terraform.workspace
    critical    = var.critical
    terraform   = "true"
  }
}

####################
# STATES S3 BUCKET #
####################

resource "aws_s3_bucket" "terraform_states" {
  bucket = "${local.org_scope}-${var.environment}-terrstates"

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = local.global_tags
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

##################
# DYNAMODB TABLE #
##################

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${local.org_scope}-${var.environment}-terrlocks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.global_tags
}
