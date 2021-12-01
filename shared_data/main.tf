####################################################################################################
### REMOTE STATES

locals {
  region_name          = var.region_names[var.region]
  is_default_workspace = (terraform.workspace == "default")
}

data "terraform_remote_state" "landing_zone" {
  backend = "s3"
  config = {
    bucket = "${var.global_prefix}-${var.environment}-terrstates"
    key    = "services/landing_zone/${var.region}/terraform.tfstate"
    region = var.states_region
  }
}
