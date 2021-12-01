
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
  vpc_security_group_ids      = var.public ? [var.public_sg] : [var.private_sg]
  subnet_id                   = var.public ? element(var.public_subnets, 0) : element(var.private_subnets, 0)
  associate_public_ip_address = var.public ? true : false

  ebs_optimized    = var.ebs_optimized
  ebs_block_device = var.ebs_block_devices

  enable_volume_tags = true

  tags = var.global_tags
}
