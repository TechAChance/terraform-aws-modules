####################################################################################################
### GLOBAL
variable "global_tags" {
  description = "map of tags"
  type        = map(any)
  default     = {}
}
variable "naming_id_prefix" {
  description = "The region where to provision aws services."
  type        = string
}
####################################################################################################
###
variable "project" {
  description = ""
  type        = string
}
variable "git_provider" {
  description = ""
  type        = string
  default     = "GITHUB"
}
variable "git_url" {
  description = ""
  type        = string
}
variable "git_branch" {
  description = ""
  type        = string
  default     = "master"
}
