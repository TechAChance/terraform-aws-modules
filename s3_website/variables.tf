####################################################################################################
### GLOBAL
variable "global_tags" {
  description = "map of tags"
  type        = map(any)
  default     = {}
}
####################################################################################################
### S3 WEB SITE
variable "bucket_name" {
  type        = string
  description = "The name of the bucket that will host the website."
}
variable "fqdn_name" {
  type        = string
  description = "The fully qualified domain name for the website."
}
