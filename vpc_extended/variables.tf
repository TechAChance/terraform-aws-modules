####################################################################################################
### VPC
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
variable "manage_default_route_table" {
  type    = bool
  default = true
}
variable "create_database_subnet" {
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
# Security Group
variable "bastion_ips_whitelist" {
  description = "List of IPs to whitelist on the Bastion security group"
  type        = any
}
variable "create_security_group_quicksight" {
  type    = bool
  default = false
}
