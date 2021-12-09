
output "arn" {
  value = aws_lb.nlb.arn
}

output "dns_name" {
  value = aws_lb.nlb.dns_name
}

output "zone_id" {
  value = aws_lb.nlb.zone_id
}

output "arn_suffix" {
  value = aws_lb.nlb.arn_suffix
}
