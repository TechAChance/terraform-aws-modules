####################################################################################################
###
variable "username" {
  description = "The name of the user"
  type        = string
}
variable "policy_arn" {
  description = "The policy arn to give to the user"
  type        = string
}
