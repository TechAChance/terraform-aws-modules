####################################################################################################
## GLOBAL
variable "global_tags" {
  description = "map of tags"
  type        = map(any)
  default     = {}
}

## SSH Keys
variable "ssh_keys" {
  description = "map of ssh_keys to create"
  type        = map(any)
  default     = {}
}
