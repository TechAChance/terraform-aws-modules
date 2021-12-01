####################################################################################################
### GLOBAL
variable "states_region" {
  description = "The region where the terrstates are stored."
  type        = string
}
variable "org" {
  description = "The organization prefix."
  type        = string
}
variable "scope" {
  description = "The scope of the service deployment."
  type        = string
}
variable "environment" {
  description = "Environment/Account where to create AWS services (dev, sand, stag, prod)."
  type        = string
}
variable "region" {
  description = "The region where to provision AWS services."
  type        = string
}
variable "service" {
  description = "The service to be provisionned."
  type        = string
}
variable "deployed_by" {
  description = "The initiator f the deployment."
  type        = string
}
variable "critical" {
  description = ""
  type        = string
  default     = "yes"
}
