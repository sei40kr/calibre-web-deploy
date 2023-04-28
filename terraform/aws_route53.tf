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
