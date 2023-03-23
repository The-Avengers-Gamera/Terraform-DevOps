output "acm_cert_arn" {
  value = aws_acm_certificate.gamera-certificates.arn
}

output "validation" {
  value = aws_acm_certificate.gamera-certificates.domain_validation_options
}

output "acm-certificate-arn" {
  value = aws_acm_certificate.gamera-certificates.arn
}