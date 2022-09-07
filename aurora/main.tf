####################################################################################################
### Aurora DATABASE
# data "aws_secretsmanager_secret_version" "db_user" {
#   secret_id = "${module.naming.resource.global_prefix}/${module.naming.resource.db_identifier}/db-user"
# }

# resource "aws_secretsmanager_secret" "db_user" {
#   name = "${module.naming.resource.global_prefix}/${module.naming.resource.db_identifier}/db-user"
# }
# variable "db_user" {
#   default = {
#     username = "dant"
#     password = "Icing-Speller-Consuming"
#   }
#   type = map(string)
# }

# resource "aws_secretsmanager_secret_version" "db_user" {
#   secret_id     = aws_secretsmanager_secret.db_user.id
#   secret_string = jsonencode(var.db_user)
# }

module "aurora_cluster" {
  source = "terraform-aws-modules/rds-aurora/aws"
  # version = "~> 3.0"

  create_cluster = var.create_cluster

  vpc_id                 = var.vpc_id
  allowed_cidr_blocks    = var.allowed_cidr_blocks
  create_db_subnet_group = var.create_db_subnet_group
  db_subnet_group_name   = var.db_subnet_group_name
  subnets                = var.subnets

  create_security_group   = var.create_security_group
  vpc_security_group_ids  = var.vpc_security_group_ids
  allowed_security_groups = var.allowed_security_groups

  name           = "${var.naming_id_prefix}-${var.engine}-${var.database_id}"
  database_name  = var.database_name
  engine         = var.engine         #"aurora-mysql"
  engine_version = var.engine_version #"5.7.12"
  engine_mode    = var.engine_mode
  instance_class = var.instance_class

  instances = {
    one = {}
  }
  autoscaling_enabled      = true
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 5

  storage_encrypted = var.storage_encrypted
  # kms_key_id                = aws_kms_key.primary.arn
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  deletion_protection = var.deletion_protection

  backup_retention_period          = var.backup_retention_period
  skip_final_snapshot              = var.skip_final_snapshot
  final_snapshot_identifier_prefix = var.final_snapshot_identifier_prefix
  copy_tags_to_snapshot            = true

  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  apply_immediately = var.apply_immediately

  create_db_parameter_group  = true
  create_db_cluster_parameter_group = true
  db_parameter_group_name         = var.db_parameter_group_name
  db_cluster_parameter_group_name = var.db_cluster_parameter_group_name

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval             = "10"
  create_monitoring_role          = true
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  create_random_password = true
  # master_password        = random_password.master.result
  # master_username        = "root"

  tags = var.global_tags
}
