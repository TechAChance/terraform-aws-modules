### VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
output "vpc_cidr" {
  description = "The CIDR of the VPC"
  value       = module.vpc.vpc_cidr_block
}
## SUBNETS
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}
output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}
output "database_subnets_cidr_blocks" {
  description = "List of CIDR blocks of database subnets"
  value       = module.vpc.database_subnets_cidr_blocks
}
output "database_subnet_group_name" {
  description = "the name of database subnets group"
  value       = module.vpc.database_subnet_group_name
}

# # NAT gateways
# output "nat_public_ips" {
#   description = "List of public Elastic IPs created for AWS NAT Gateway"
#   value       = module.vpc.nat_public_ips
# }
### SECURITY GROUPS
output "public_sg" {
  description = "Id of public security group."
  value       = module.security_group_public.security_group_id
}
output "private_sg" {
  description = "Id of private security group."
  value       = module.security_group_private.security_group_id
}
output "database_sg" {
  description = "Id of database security group"
  value       = module.security_group_database.security_group_id
}
output "bastion_sg" {
  description = "Id of bastion security group"
  value       = module.security_group_bastion.security_group_id
}
