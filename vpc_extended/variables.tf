####################################################################################################
## GLOBAL
variable "region" {
  description = "The region where to provision aws services."
  type        = string
}
variable "naming_id_prefix" {
  description = "The region where to provision aws services."
  type        = string
}
variable "global_tags" {
  description = "map of tags"
  type        = map(any)
  default     = {}
}
####################################################################################################
## VPC
variable "vpc_cidr" {
  description = "The CIDR of the VPC."
  type        = string
  default     = "10.0.0.0/16"
}
variable "vpc_public_subnets" {
  description = "The CIDR of the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "vpc_private_subnets" {
  description = "The CIDR of the private subnets."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}
variable "vpc_database_subnets" {
  description = "The CIDR of the private subnets."
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}
variable "create_database_subnet_group" {
  type    = bool
  default = true
}
variable "create_database_subnet_route_table" {
  type    = bool
  default = true
}
variable "enable_dns_hostnames" {
  type    = bool
  default = true
}
variable "enable_nat_gateway" {
  type    = bool
  default = false
}
variable "create_security_group_database" {
  type    = bool
  default = true
}
variable "create_security_group_quicksight" {
  type    = bool
  default = false
}
