locals {
  azs = slice(data.aws_availability_zones.available.names, 0, length(var.public_subnets))
}

module "vpc" {
  source = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
  aws_region = var.aws_region
  azs = local.azs
  database_subnets = var.database_subnets
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  tag_name = var.tag_name
  security_group_common="kandula-common-sg"
}


#module "jenkins_server"  {
#  source = "../modules/jenkins_server"
#  private_ip = var.jenkins_server_private_ip
#  ami_id = data.aws_ami.jenkins-ami.id
#  instance_type               = "t3.micro"
#  key_name                    = var.jenkins_key
#  subnet_id                   = module.vpc.private_subnets[0].id
#  public_subnet_ids           = module.vpc.public_subnets.*.id
#  vpc_id                      = module.vpc.vpc_id
#  vpc_cidr                    = var.vpc_cidr
#  efs_id                      = data.aws_efs_file_system.efs.id
#  efs_dns                     = data.aws_efs_file_system.efs.dns_name
#  aws_region                  = var.aws_region
#  common_sg                   = module.vpc.common_sg_id
#  create_lb                   = var.create_lb
#  #aws_acm_certificate_arn = aws_acm_certificate.cert.arn
#  tag_name = var.tag_name
#}


#resource "aws_route53_record" "jenkins_record" {
#  count = var.create_lb ? 1 : 0
#  zone_id = data.aws_route53_zone.selected.zone_id
#  #zone_id = aws_route53_zone.myZone[0].zone_id
#  name    = "jenkins"
#  type    = "CNAME"
#  ttl =  60
#  records = [module.jenkins_server.lb_jenkins_dns[0]]
#}


