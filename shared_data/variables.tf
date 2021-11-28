####################################################################################################
## GLOBAL
variable "states_region" {
  description = "The region where the terrstates are stored."
  type        = string
  default     = ""
}

variable "global_prefix" {
  description = "The org or org-scope name."
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment/Account where to create AWS services (dev, sand, stag, prod)."
  type        = string
  default     = ""
}

variable "region" {
  description = "The region where to provision aws services."
  type        = string
  default     = ""
}

variable "service" {
  description = "The service to be provisionned."
  type        = string
  default     = ""
}

variable "region_names" {
  type = map(any)
  default = {
    "eu-west-1" = "ireland",
    "eu-west-3" = "paris"
  }
}
