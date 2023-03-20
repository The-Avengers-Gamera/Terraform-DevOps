terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.57.1"
    }
  }
}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name

  tags = {
    Environment = var.tags
  }
}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" { 
  bucket = aws_s3_bucket.bucket.id

  policy = data.aws_iam_policy_document.allow_access_from_another_account.json

data "aws_iam_policy_document" "allow_access_from_another_account" {
  version = "2012-10-17"
  statement {
    Effect    = "Allow"
    principals = "*"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.example.arn,
      "${aws_s3_bucket.example.arn}/*",
      ]
    }
  } 
}