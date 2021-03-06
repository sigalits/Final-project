
resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${data.aws_route53_zone.selected.name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "acm_verification" {
  zone_id = data.aws_route53_zone.selected.zone_id
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  ttl     = "60"
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
}


resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.acm_verification.fqdn]
}
// This resource doesn't create anything
// it just waits for the certificate to be created, and validation to succeed, before being created
resource "time_sleep" "wait_for_certificate_verification" {
  depends_on = [aws_acm_certificate_validation.cert]
  create_duration = "60s"
}
