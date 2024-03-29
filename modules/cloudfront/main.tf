locals {
  s3-origin-id = "${var.environment}-${var.project-name}-s3-origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.website-bucket.bucket_regional_domain_name
    origin_id   = local.s3-origin-id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront-oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN for ${var.project-name}'s website in ${var.environment} environment"
  default_root_object = "index.html"

  aliases = ["${var.record-prefix}.${var.hosted-zone}"]

  viewer_certificate {
    acm_certificate_arn      = var.acm-certificate-arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3-origin-id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3-origin-id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3-origin-id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = var.environment == "dev" ? "PriceClass_100" : "PriceClass_All"

  tags = {
    Environment = var.environment
  }
}

resource "aws_cloudfront_origin_access_identity" "cloudfront-oai" {
  comment = "OAI for accessing ${var.project-name}'s website bucket in ${var.environment} environment"
}