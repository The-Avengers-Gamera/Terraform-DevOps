resource "aws_acm_certificate" "gamera-certificates" {
  domain_name               = var.domain-name
  subject_alternative_names = var.subject-alternative-names
  validation_method         = "DNS"
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.gamera-certificates.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = var.hosted-zone-id
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "gamera-certificates-validation" {
  certificate_arn         = aws_acm_certificate.gamera-certificates.arn
  validation_record_fqdns = values(aws_route53_record.validation)[*].fqdn
}