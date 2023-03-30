output "cloudfront-distribution" {
  value       = aws_cloudfront_distribution.s3_distribution
  description = "The cloudfront distribution"
}

output "cloudfront-oai-id" {
  value       = aws_cloudfront_origin_access_identity.cloudfront-oai.id
  description = "The id of cloudfront's origin access identity"
}

output "cloudfront-id" {
  value = aws_cloudfront_distribution.s3_distribution.id
  description = "The id of cloudfront distribution"
}