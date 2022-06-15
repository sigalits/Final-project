resource "aws_route53_zone" "myZone" {
  name = var.domain_name
  lifecycle {
    prevent_destroy = true
  }
}
