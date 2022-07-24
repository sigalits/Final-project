resource "aws_route53_record" "kibana_record" {
  count = var.create_eks? 1 : 0
  zone_id = data.aws_route53_zone.selected.id
  name    = "kibana"
  type    = "CNAME"
  ttl =  60
  records = [aws_lb.ops_lb[0].dns_name]
}

resource "aws_route53_record" "consul_record" {
  count = var.create_consul_servers ? 1 : 0
  zone_id = data.aws_route53_zone.selected.id
  name    = "consul"
  type    = "CNAME"
  ttl =  60
  records = [aws_lb.ops_lb[0].dns_name]
}


resource "aws_route53_record" "jenkins_record" {
  count = var.create_lb? 1 : 0
  zone_id = data.aws_route53_zone.selected.zone_id
  #zone_id = aws_route53_zone.myZone[0].zone_id
  name    = "jenkins"
  type    = "CNAME"
  ttl =  60
  records = [aws_lb.ops_lb[0].dns_name]
}

resource "aws_route53_record" "database" {
  count = var.create_rds ? 1 : 0
  zone_id = data.aws_route53_zone.selected.id
  name = var.instance_name
  type = "CNAME"
  ttl = "60"
  records = [aws_db_instance.kandula-db[0].address]
}
