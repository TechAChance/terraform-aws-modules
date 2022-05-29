resource "aws_iam_user" "user" {
  name = var.username
  path = "/"

  tags = var.global_tags
}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy_attachment" "attach-policy" {
  user       = aws_iam_user.user.name
  policy_arn = var.policy_arn
}
