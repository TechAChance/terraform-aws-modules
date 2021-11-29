############
# ROUTE 53 #
############

resource "aws_route53_zone" "zones" {
  for_each = var.create_route_53_zones ? var.route_53_zones : tomap({})

  name          = lookup(each.value, "domain_name", each.key)
  comment       = lookup(each.value, "comment", null)
  force_destroy = lookup(each.value, "force_destroy", false)

  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.region
  }

  tags = var.global_tags
}

resource "aws_acm_certificate" "cert" {

  for_each = {
    for route_53_zone in var.route_53_zones : route_53_zone.create_certificate => {
      domain_name = route_53_zone.domain_name
    }
  }

  domain_name       = each.value.domain_name
  validation_method = "DNS"

  tags = var.global_tags

  lifecycle {
    create_before_destroy = true
  }
}
