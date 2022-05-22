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


module "jenkins_server"  {
  source = "../modules/jenkins_server"
  private_ip = var.jenkins_server_private_ip
  ami_id = data.aws_ami.jenkins-ami.id
  instance_type               = "t3.micro"
  key_name                    = var.jenkins_key
  subnet_id                   = module.vpc.private_subnets[0].id
  public_subnet_ids           = module.vpc.public_subnets.*.id
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name
  vpc_id                      = module.vpc.vpc_id
  common_sg = module.vpc.common_sg_id
  jenkins_lb_sg = aws_security_group.jenkins_lb_sg.id
  jenkins_sg = aws_security_group.jenkins_server.id
  # user_data = file("${path.module}/user_data_jenkins.sh")
  tag_name = var.tag_name
}

resource "aws_route53_zone" "myZone" {
  count = var.create_dns ? 1 : 0
  name = "sigalits.kandula.com"
}


resource "aws_route53_record" "myRecord" {
  zone_id = aws_route53_zone.myZone[0].zone_id
  name    = "www.sigalits.kandula.com" # OR "www.example.com"
  type    = "A" # OR "AAAA"

  alias {
      name                   = module.jenkins_server.lb_jenkins_dns
      zone_id                = module.jenkins_server.lb_zone_id
      evaluate_target_health = false
  }
}


