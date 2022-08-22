####################################################################################################
## DATABASE
variable "create_cluster" {
  description = "Whether cluster should be created (affects nearly all resources)"
  type        = bool
  default     = true
}
# VPC & subnets
variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = ""
}
variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = []
}
variable "create_db_subnet_group" {
  description = "Determines whether to create the database subnet group or use existing"
  type        = bool
  default     = false
}
variable "db_subnet_group_name" {
  description = "The name of the subnet group name (existing or created)"
  type        = string
}
variable "subnets" {
  description = "List of subnet IDs used by database subnet group created"
  type        = list(string)
  default     = []
}
# SECURITY GROUPS
variable "create_security_group" {
  description = "Determines whether to create security group for RDS cluster"
  type        = bool
  default     = false
}
variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate to the cluster in addition to the SG we create in this module"
  type        = list(string)
  default     = []
}
variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to"
  type        = list(string)
  default     = []
}
# DB
variable "database_id" {
  description = "The DB Id."
  type        = string
  default     = "db"
}
variable "database_name" {
  description = "The DB Name."
  type        = string
  default     = ""
}
variable "engine" {
  description = "The RDS engine."
  type        = string
  default     = "aurora-mysql"
}
variable "engine_version" {
  description = "The RDS engine version."
  type        = string
  default     = "8.0.mysql_aurora.3.02.0"
}
variable "engine_mode" {
  description = "The RDS engine mode."
  type        = string
  default     = "provisioned"
}
variable "instance_class" {
  description = "Instance type to use at master instance. Note: if `autoscaling_enabled` is `true`, this will be the same instance class used on instances created by autoscaling"
  type        = string
  default     = "db.t4g.medium"
}
# DB PARAMS
variable "storage_encrypted" {
  description = ""
  type        = bool
  default     = true
}
variable "iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  type        = bool
  default     = true
}
variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`. The default is `false`"
  type        = bool
  default     = null
}

variable "backup_retention_period" {
  description = "The days to retain backups for. Default `7`"
  type        = number
  default     = 7
}
variable "skip_final_snapshot" {
  description = "Determines whether a final snapshot is created before the cluster is deleted. If true is specified, no snapshot is created"
  type        = bool
  default     = false
}
variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy; a 8 random digits are appended to name to ensure it's unique"
  default     = "final-snapshot"
  type        = string
}

variable "preferred_backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Must not overlap with maintenance_window."
  default     = "02:00-03:00"
  type        = string
}
variable "preferred_maintenance_window" {
  description = "The window to perform maintenance in."
  default     = "Mon:03:00-Mon:05:00"
  type        = string
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. Default is `false`"
  type        = bool
  default     = null
}
variable "db_parameter_group_name" {
  description = "The name of the DB parameter group to associate with instances"
  type        = string
  default     = null
}
variable "db_cluster_parameter_group_name" {
  description = "A cluster parameter group to associate with the cluster"
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Set of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: `audit`, `error`, `general`, `slowquery`, `postgresql`"
  type        = list(string)
  default     = ["error"]
}

variable "create_random_password" {
  description = "Determines whether to create random password for RDS primary cluster"
  type        = bool
  default     = true
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "root"
}

variable "master_password" {
  description = "Password for the master DB user. Note - when specifying a value here, 'create_random_password' should be set to `false`"
  type        = string
  default     = null
}
