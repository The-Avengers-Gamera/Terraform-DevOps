resource "aws_s3_bucket" "website-bucket" {
  bucket = "${var.environment}-${var.project-name}-website-bucket"
}

resource "aws_s3_bucket_website_configuration" "website-configuration" {
  bucket = aws_s3_bucket.website-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
