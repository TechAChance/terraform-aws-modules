####################################################################################################
### GLOBAL
variable "vpc_id" {
  description = "The id of the VPC."
  type        = string
}
variable "region" {
  description = "The region where to provision aws services."
  type        = string
}
variable "global_tags" {
  description = "map of tags"
  type        = map(any)
  default     = {}
}
####################################################################################################
### ROUTE 53
variable "create_route_53_zones" {
  description = "Whether to create Route53 zone"
  type        = bool
  default     = false
}
variable "route_53_zones" {
  description = "Map of Route53 zone parameters"
  type        = any
  default     = {}
}
