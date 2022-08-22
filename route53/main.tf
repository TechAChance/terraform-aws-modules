####################################################################################################
### ROUTE 53

resource "aws_route53_zone" "zones" {
  for_each = var.create_route_53_zones ? var.route_53_zones : tomap({})

  name          = lookup(each.value, "domain_name", each.key)
  comment       = lookup(each.value, "comment", null)
  force_destroy = lookup(each.value, "force_destroy", false)

  dynamic "vpc" {
    for_each = each.value.public ? [] : [1]
    content {
      vpc_id     = var.vpc_id
      vpc_region = var.region
    }
  }

  tags = var.global_tags
}

resource "aws_acm_certificate" "cert" {

  for_each = {
    for route_53_zone in var.route_53_zones : route_53_zone.domain_name => {
      domain_name = route_53_zone.domain_name
    } if route_53_zone.create_certificate

  }

  domain_name       = each.value.domain_name
  validation_method = "DNS"

  tags = var.global_tags

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [ aws_route53_zone.zones ]
}

## TODO: add automatically DNS validation record
# resource "aws_route53_record" "example" {
#   for_each = {
#     for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
#       name    = dvo.resource_record_name
#       record  = dvo.resource_record_value
#       type    = dvo.resource_record_type
#       zone_id = dvo.domain_name == "example.org" ? data.aws_route53_zone.example_org.zone_id : data.aws_route53_zone.example_com.zone_id
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = each.value.zone_id
# }
# resource "aws_acm_certificate_validation" "example" {
#   certificate_arn         = aws_acm_certificate.example.arn
#   validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
# }
