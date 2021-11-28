####################################################################################################
## VARIABLES

## SSH Keys
variable "ssh_keys" {
  description = "map of ssh_keys to create"
  type        = map(any)
  default     = {}
}

variable "global_tags" {
  description = "map of tags"
  type        = map(any)
  default     = {}
}
