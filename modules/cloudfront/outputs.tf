output "cloudfront-distributions" {
  value       = aws_cloudfront_distribution.s3_distribution
  description = "This is the list of cloudfront distributions"
}

output "cloudfront-oai-id" {
  value       = aws_cloudfront_origin_access_identity.cloudfront-oai.id
  description = "The id of cloudfront's origin access identity"
}