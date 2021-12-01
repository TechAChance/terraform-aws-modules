
####################################################################################################
### EC2

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = var.name

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.default_key_name
  disable_api_termination     = var.disable_api_termination
  monitoring                  = var.monitoring
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.public

  ebs_optimized    = var.ebs_optimized
  ebs_block_device = var.ebs_block_devices

  enable_volume_tags = true

  tags = var.global_tags
}
