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

  manage_default_route_table = var.manage_default_route_table
  default_route_table_tags   = merge(var.global_tags, { default_route_table = true })

  create_database_subnet_group       = var.create_database_subnet
  create_database_subnet_route_table = var.create_database_subnet

  # create_elasticache_subnet_route_table = true
  # create_redshift_subnet_route_table    = true

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = true

  enable_classiclink             = true
  enable_classiclink_dns_support = true

  enable_nat_gateway = var.enable_nat_gateway
  # single_nat_gateway = true
  enable_vpn_gateway = false

  tags = var.global_tags
}

####################################################################################################
### SECURITY GROUPS
locals {
  bastion_cidr_blocks = join(",", [for key, value in var.bastion_ips_whitelist : value.ip])
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
      cidr_blocks = local.bastion_cidr_blocks
      description = "Allow ssh access"
    },
    {
      rule        = "http-80-tcp"
      cidr_blocks = local.bastion_cidr_blocks
      description = "Allow http access"
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = local.bastion_cidr_blocks
      description = "Allow https access"
    },
  ]
  ingress_with_self = [{ rule = "all-all" }]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.global_tags
}

module "security_group_public" {
  source = "terraform-aws-modules/security-group/aws"

  create = true

  vpc_id      = module.vpc.vpc_id
  name        = "${var.naming_id_prefix}-public-sg"
  description = "Security group with HTTP(s) port open for everyone."

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "https-8443-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.security_group_bastion.security_group_id
      description              = "Allow all from Bastion"
    }
  ]
  ingress_with_self = [{ rule = "all-all", description = "Allow all from self" }]

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
      description              = "Allow 80 from Public SG"
    },
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = module.security_group_public.security_group_id
      description              = "Allow 8080 from Public SG"
    },
    {
      rule                     = "https-443-tcp"
      source_security_group_id = module.security_group_public.security_group_id
      description              = "Allow 443 from Public SG"
    },
    {
      rule                     = "https-8443-tcp"
      source_security_group_id = module.security_group_public.security_group_id
      description              = "Allow 8443 from Public SG"
    },
    {
      rule                     = "all-all"
      source_security_group_id = module.security_group_bastion.security_group_id
      description              = "Allow all from Bastion"
    }
  ]
  ingress_with_self = [{ rule = "all-all", description = "Allow all from self" }]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.global_tags
}

module "security_group_database" {
  source = "terraform-aws-modules/security-group/aws"

  create = var.create_database_subnet

  vpc_id      = module.vpc.vpc_id
  name        = "${var.naming_id_prefix}-database-sg"
  description = "Security group with MySQL/Aurora/MariaDB ports open from public and private"

  ## TODO: remove access from public sg ?
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.security_group_public.security_group_id
      description              = "Allow MySQL from Public SG"
    },
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.security_group_private.security_group_id
      description              = "Allow MySQL from Private SG"
    },
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.security_group_public.security_group_id
      description              = "Allow PostgreSQL from Public SG"
    },
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.security_group_private.security_group_id
      description              = "Allow PostgreSQL from Private SG"
    },
    {
      rule                     = "mssql-tcp"
      source_security_group_id = module.security_group_public.security_group_id
      description              = "Allow MS SQL from Public SG"
    },
    {
      rule                     = "mssql-tcp"
      source_security_group_id = module.security_group_private.security_group_id
      description              = "Allow MS SQL from Private SG"
    },
    {
      rule                     = "all-all"
      source_security_group_id = module.security_group_bastion.security_group_id
      description              = "Allow all from Bastion"
    },
  ]
  ingress_with_self = [{ rule = "all-all", description = "Allow all from self" }]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.global_tags
}

module "security_group_quicksight" {
  source = "terraform-aws-modules/security-group/aws"

  create = var.create_security_group_quicksight

  vpc_id      = module.vpc.vpc_id
  name        = "${var.naming_id_prefix}-quicksight-sg"
  description = "Security group for Amazon Quicksigth for MySQL/Aurora/MariaDB/PostgreSql... access"

  ingress_with_cidr_blocks = [
    {
      rule        = "mysql-tcp"
      cidr_blocks = "52.210.255.224/27,35.158.127.192/27,35.177.218.0/27"
      description = "Allow access from Quicksight Ireland/Frankfurt/London to Mysql port"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "52.210.255.224/27,35.158.127.192/27,35.177.218.0/27"
      description = "Allow access from Quicksight Ireland/Frankfurt/London to PostgreSQL port"
    },
    {
      rule        = "mssql-tcp"
      cidr_blocks = "52.210.255.224/27,35.158.127.192/27,35.177.218.0/27"
      description = "Allow access from Quicksight Ireland/Frankfurt/London to MSSQL port"
    },
  ]
  # ingress_with_self = [{ rule = "all-all" }]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.global_tags
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
