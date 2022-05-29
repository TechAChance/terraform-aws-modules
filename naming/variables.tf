####################################################################################################
### GLOBAL
variable "org" {
  description = "The organization prefix."
  type        = string
  default     = ""
}
variable "scope" {
  description = "The scope name."
  type        = string
  default     = ""
}
variable "platform_region" {
  description = "The platform_region name."
  type        = string
  default     = ""
}
variable "global_prefix" {
  description = "The global prefix."
  type        = string
  default     = ""
}
variable "environment" {
  description = "Environment/Account where to create AWS services (dev, sbx, tst, dmo, sit, uat, stg, prd)."
  type        = string
  default     = ""
}
variable "service" {
  description = "The service to be provisionned."
  type        = string
  default     = ""
}
variable "region" {
  description = "The region where to provision aws services."
  type        = string
  default     = ""
}
variable "subdomain" {
  description = "The subdomain."
  type        = string
  default     = ""
}
variable "record_dns_name_prefix" {
  description = ""
  type        = string
  default     = "%s"
}
