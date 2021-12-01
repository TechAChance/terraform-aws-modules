####################################################################################################
## GLOBAL
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
## EC2
variable "name" {
  description = "Name"
  type        = string
}
variable "ami" {
  description = "The ami."
  type        = string
}
variable "instance_type" {
  description = "The instance type."
  type        = string
}
variable "default_key_name" {
  description = "The name of the default key."
  type        = string
  default     = ""
}
variable "disable_api_termination" {
  description = ""
  type        = bool
  default     = false
}
variable "monitoring" {
  description = ""
  type        = bool
  default     = false
}
variable "public" {
  description = ""
  type        = bool
  default     = false
}
public_sg
private_sg
public_subnets
private_subnets
variable "ebs_optimized" {
  description = ""
  type        = bool
  default     = false
}
variable "ebs_block_devices" {
  description = ""
  type        = list(any)
  default     = []
}
