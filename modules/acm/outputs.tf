output "validation" {
  value = aws_acm_certificate.gamera-certificates.domain_validation_options
}

output "acm_certificate" {
  value = aws_acm_certificate.gamera-certificates
}

output "acm-certificate-arn" {
  value = aws_acm_certificate.gamera-certificates.arn
}