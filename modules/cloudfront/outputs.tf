output cloudfront-distributions {
  value       = aws_cloudfront_distribution.s3_distribution
  description = "This is the list of cloudfront distributions"
}