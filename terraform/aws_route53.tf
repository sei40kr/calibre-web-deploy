data "aws_route53_zone" "yong_ju_me" {
  name = "yong-ju.me"
}

resource "aws_route53_record" "calibre" {
  name    = "calibre.yong-ju.me"
  records = [oci_core_instance.calibre_web.public_ip]
  ttl     = 60
  type    = "A"
  zone_id = data.aws_route53_zone.yong_ju_me.zone_id
}

resource "aws_route53_record" "calibre_domain_validation" {
  for_each = {
  for dvo in aws_acm_certificate.calibre.domain_validation_options : dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.yong_ju_me.zone_id
}
