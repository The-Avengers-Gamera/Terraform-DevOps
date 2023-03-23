resource "aws_s3_bucket" "website-host-bucket" {
  bucket = var.website-bucket-name
}

resource "aws_s3_bucket_acl" "website-host-bucket-acl" {
  bucket = aws_s3_bucket.website-host-bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.website-host-bucket.id
  policy = templatefile("${path.module}/policy.json", { bucket-name = var.website-bucket-name })
}

resource "aws_s3_bucket_website_configuration" "website-configuration" {
  bucket = aws_s3_bucket.website-host-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}