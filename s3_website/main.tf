####################################################################################################
### S3 WEB SITE

resource "aws_s3_bucket" "web_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = templatefile("s3-policy.json", { bucket_name = "${var.bucket_name}" })

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://${var.fqdn_name}"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = var.global_tags
}
