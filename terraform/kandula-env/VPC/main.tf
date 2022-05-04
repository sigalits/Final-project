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
}

#Create security group for kandula servers
resource "aws_security_group" "kandula-sg" {
  name        = var.security_group_kandula
  description = "security group for kandula"
  vpc_id = module.vpc.vpc_id
}




