output "access_key" {
  value = aws_iam_access_key.access_key.id
}

output "secret_key" {
  sensitive = true
  value     = aws_iam_access_key.access_key.secret
}
