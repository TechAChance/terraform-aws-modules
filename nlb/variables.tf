####################################################################################################
### GLOBAL
variable "global_tags" {
  description = "map of tags"
  type        = map(any)
  default     = {}
}
####################################################################################################
### NLB
variable "name" {
  default     = ""
  description = "Name of the NLB"
}
variable "enable_deletion_protection" {
  description = "Nlb Termination Protection"
  type        = bool
  default     = false
}
variable "is_internal" {
  description = "Is Nlb internal or not?"
  type        = bool
  default     = false
}
variable "cross_az_lb" {
  description = ""
  type        = bool
  default     = true
}
variable "subnets" {
  type    = list(any)
  default = []
}
