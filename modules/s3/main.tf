variable bucket-name {
  type        = string
  description = "description"
}


resource "aws_s3_bucket" "gamera-s3-bucket" {
  bucket = var.bucket-name

  tags = {
    Name        = "${var.bucket-name}"
    Environment = "Dev"
  }
}

/*
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}*/