output "ec2_instance" {
  value = module.ec2_instance
}
output "elastic_ip" {
  value = aws_eip.eip
}
