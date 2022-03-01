resource "aws_acm_certificate" "calibre" {
  domain_name = "calibre.yong-ju.me"
  lifecycle {
    create_before_destroy = true
  }
  provider          = aws.us_east_1
  validation_method = "DNS"
  tags              = {
    Owner = "calibre"
  }
}

resource "aws_acm_certificate_validation" "calibre" {
  certificate_arn         = aws_acm_certificate.calibre.arn
  provider                = aws.us_east_1
  validation_record_fqdns = [for record in aws_route53_record.calibre_domain_validation : record.fqdn]
}