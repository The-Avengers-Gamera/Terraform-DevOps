output "website-bucket" {
  value       = aws_s3_bucket.website-bucket
  description = "This is the bucket used to host website"
}
