####################################################################################################
### VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  # version = "3.7.0"

  # insert the 21 required variables here
  name = "${var.naming_id_prefix}-vpc"
  cidr = var.vpc_cidr

  azs = ["${var.region}a", "${var.region}b", "${var.region}c"]

  public_subnets   = var.vpc_public_subnets
  private_subnets  = var.vpc_private_subnets
  database_subnets = var.vpc_database_subnets
  # elasticache_subnets = ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]
  # redshift_subnets    = ["10.10.41.0/24", "10.10.42.0/24", "10.10.43.0/24"]

  create_database_subnet_group = var.create_database_subnet_group

  manage_default_route_table         = true
  create_database_subnet_route_table = var.create_database_subnet_route_table
  # create_elasticache_subnet_route_table = true
  # create_redshift_subnet_route_table    = true
  default_route_table_tags = { DefaultRouteTable = true }

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = true

  enable_classiclink             = true
  enable_classiclink_dns_support = true

  enable_nat_gateway = var.enable_nat_gateway
  # single_nat_gateway = true
  enable_vpn_gateway = false

  tags = var.global_tags
}

module "security_group_public" {
  source = "terraform-aws-modules/security-group/aws"

  create = true

  vpc_id      = module.vpc.vpc_id
  name        = "${var.naming_id_prefix}-public-sg"
  description = "Security group with HTTP(s) port open for everyone."

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]
  ingress_with_self   = [{ rule = "all-all" }]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.global_tags
}

module "security_group_private" {
  source = "terraform-aws-modules/security-group/aws"

  create = true

  vpc_id      = module.vpc.vpc_id
  name        = "${var.naming_id_prefix}-private-sg"
  description = "Security group with HTTP(s) port open from public and self"

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.security_group_public.security_group_id
    },
    {
      rule                     = "https-443-tcp"
      source_security_group_id = module.security_group_public.security_group_id
    },
    {
      rule                     = "all-all"
      source_security_group_id = module.security_group_bastion.security_group_id
    }
  ]
  ingress_with_self = [{ rule = "all-all" }]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.global_tags

  depends_on = [
    module.security_group_public,
    module.security_group_bastion
  ]
}

module "security_group_database" {
  source = "terraform-aws-modules/security-group/aws"

  create = var.create_security_group_database

  vpc_id      = module.vpc.vpc_id
  name        = "${var.naming_id_prefix}-database-sg"
  description = "Security group with MySQL/Aurora/MariaDB ports open from public and private"

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.security_group_public.security_group_id
    },
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.security_group_private.security_group_id
    },
    ##TODO: make this part is conditional or always add quicksight sg
    # {
    #   rule                     = "mysql-tcp"
    #   source_security_group_id = module.security_group_quicksight.security_group_id
    # },
    {
      rule                     = "all-all"
      source_security_group_id = module.security_group_bastion.security_group_id
    },
  ]
  ingress_with_self = [{ rule = "all-all" }]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.global_tags

  depends_on = [
    module.security_group_public,
    module.security_group_private,
    module.security_group_bastion
  ]
}

module "security_group_bastion" {
  source = "terraform-aws-modules/security-group/aws"

  create = true

  vpc_id      = module.vpc.vpc_id
  name        = "${var.naming_id_prefix}-bastion-sg"
  description = "Security group with SSH port open for Bastions connections"

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "82.65.219.56/32"
    },
  ]

  ingress_with_self = [{ rule = "all-all" }]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.global_tags
}

module "security_group_quicksight" {
  source = "terraform-aws-modules/security-group/aws"

  create = var.create_security_group_quicksight

  vpc_id      = module.vpc.vpc_id
  name        = "${var.naming_id_prefix}-quicksight-sg"
  description = "Security group for Amazon Quickgth for MySQL/Aurora/MariaDB/... access"

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.security_group_database.security_group_id
    }
  ]
  # ingress_with_self = [{ rule = "all-all" }]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.global_tags

  depends_on = [
    module.security_group_database
  ]
}

# ingress_with_source_security_group_id = [
#   {
#     rule                     = "https-443-tcp"
#     source_security_group_id = data.aws_security_group.default.id
#   },
# ]

# mysql-tcp
# ingress {
#     from_port = 3306
#     to_port = 3306
#     protocol = "tcp"
#     security_groups = aws_security_group.sg1.id

# }

# egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]

# }

# ingress_with_source_security_group_id = [
#     {
#       rule                     = "mysql-tcp"
#       source_security_group_id = data.aws_security_group.default.id
#     },

# ingress_with_self = [
#   {
#     rule = "all-all"
#   },
