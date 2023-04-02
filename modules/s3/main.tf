resource "aws_s3_bucket" "website-bucket" {
  bucket = "${var.environment}-${var.project-name}-website-bucket"
}

resource "aws_s3_bucket_website_configuration" "website-configuration" {
  bucket = aws_s3_bucket.website-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "allow_cloudfront_access" {
  bucket = aws_s3_bucket.website-bucket.id
  policy = templatefile("${path.module}/policy.json",
  { bucket-name = aws_s3_bucket.website-bucket.id, cloudfront-oai-id = var.cloudfront-oai-id })
}