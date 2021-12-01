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
variable "public_sg" {
  description = "The public security group."
  type        = string
}
variable "private_sg" {
  description = "The private security group."
  type        = string
}
variable "public_subnets" {
  description = "The public subnets"
  type        = list(any)
}
variable "private_subnets" {
  description = "The private subnets"
  type        = list(any)
}
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
