####################################################################################################
### SSH KEY PAIRS

resource "aws_key_pair" "deployer" {
  for_each = var.ssh_keys

  key_name   = each.key
  public_key = each.value.public_key

  tags = var.global_tags
}
