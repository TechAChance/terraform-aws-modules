####################################################################################################
### GLOBAL
variable "region" {
  description = "The region where to provision aws services."
  type        = string
  default     = ""
}
variable "naming_id_prefix" {
  description = "The region where to provision aws services."
  type        = string
  default     = ""
}
variable "global_tags" {
  description = "map of tags"
  type        = map(any)
  default     = {}
}
