output "gamera-website-host-buckets" {
  value       = aws_s3_bucket.website-host-bucket
  description = "This is the list of gamera's website host buckets"
}
