####################################################################################################
### GLOBAL
variable "global_tags" {
  description = "map of tags"
  type        = map(any)
  default     = {}
}
####################################################################################################
### EC2
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
variable "elastic_ip" {
  description = ""
  type        = bool
  default     = false
}
variable "vpc_security_group_ids" {
  description = "The security group(s)."
  type        = list(any)
}
variable "subnet_id" {
  description = "The subnet"
  type        = string
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
