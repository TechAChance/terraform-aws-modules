####################################################################################################
### NLB
resource "aws_lb" "nlb" {
  name                             = var.name
  internal                         = var.is_internal
  load_balancer_type               = "network"
  subnets                          = var.subnets
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.cross_az_lb
  tags                             = var.global_tags
}
