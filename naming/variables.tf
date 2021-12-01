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
