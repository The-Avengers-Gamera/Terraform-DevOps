output "website-bucket" {
  value       = aws_s3_bucket.website-bucket
  description = "This is the bucket used to host website"
}

output "bucket-name" {
  value       = aws_s3_bucket.website-bucket.id
  description = "The name of bucket which host website"
}