### ROUTE 53
output "route_53_zones" {
  description = "Route53 zones of this vpc"
  value       = aws_route53_zone.zones
}
