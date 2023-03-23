data "aws_route53_zone" "gamera-hosted-zone" {
  name         = var.gamera-hosted-zone
  private_zone = false
}

resource "aws_route53_record" "richard-gamera-record" {
  count = var.environment == "prod" ? 2 : 1

  zone_id = data.aws_route53_zone.gamera-hosted-zone.zone_id
  name    = "${count.index == 0 ? "dev" : "prod"}.richard.gamera.com.au"
  type    = "A"

  alias {
    name                   = var.cloudfront-distributions[count.index].domain_name
    zone_id                = var.cloudfront-distributions[count.index].hosted_zone_id
    evaluate_target_health = false
  }
}