resource "aws_s3_bucket" "website-host-bucket" {
  count = var.environment == "prod" ? 2 : 1

  bucket = "${count.index == 0 ? "dev" : "prod"}.richard.gamera.com.au"
}

resource "aws_s3_bucket_acl" "website-host-bucket-acl" {
  count = var.environment == "prod" ? 2 : 1

  bucket = aws_s3_bucket.website-host-bucket[count.index].id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  count = var.environment == "prod" ? 2 : 1

  bucket = aws_s3_bucket.website-host-bucket[count.index].id
  policy = templatefile("${path.module}/policy.json",
  { bucket-name = "${count.index == 0 ? "dev" : "prod"}.richard.gamera.com.au" })
}


resource "aws_s3_bucket_website_configuration" "website-configuration" {
  count = var.environment == "prod" ? 2 : 1


  bucket = aws_s3_bucket.website-host-bucket[count.index].id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
