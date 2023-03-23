resource "aws_s3_bucket" "website-host-bucket" {
  bucket = var.website-bucket-name
  acl    = "public-read"
  policy = templatefile("${path.module}/policy.json", { bucket-name = var.website-bucket-name })

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}