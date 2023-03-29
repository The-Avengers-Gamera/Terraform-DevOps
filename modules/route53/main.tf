data "aws_route53_zone" "hosted-zone" {
  name         = var.hosted-zone
  private_zone = false
}

resource "aws_route53_record" "route-record" {
  zone_id = data.aws_route53_zone.hosted-zone.zone_id
  name    = "${var.record-prefix}.${var.hosted-zone}"
  type    = "A"

  alias {
    name                   = var.alias-dns-name
    zone_id                = var.alias-zone-id
    evaluate_target_health = false
  }
}