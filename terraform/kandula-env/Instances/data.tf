data "aws_ami" "ubuntu-18" {
  most_recent = true
  owners      = [var.ubuntu_account_number]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "jenkins-ami" {
  most_recent = true
  owners      = ["797686858489"]

  filter {
    name   = "name"
    values = ["jenkins-master*"]
  }
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = "aws_keys_kandula"
}

data "external" "secret_json" {
  program = ["echo", "${data.aws_secretsmanager_secret_version.secret.secret_string}"]
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc"  "vpc" {
   filter {
    name   = "tag:Name"
    values = ["${var.tag_name}-vpc"]
    }
}


data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-state-kandula"
    key    = "VPC/vpc_terraform.tfstate"
    region = "us-east-1"
  }
}


data "aws_route53_zone" "selected" {
  name         = "${data.terraform_remote_state.vpc.outputs.domain_name}."
  private_zone = false
}


data "aws_efs_file_system" "efs"{
  tags = {
    Name = "jenkins-master-efs"
  }
}


#data "terraform_remote_state" "vpc" {
#  backend = "remote"
#  config = {
#    organization = "Opsschool-sigalits"
#    workspaces = {
#      name = "sigalits-opschool-vpc"
#    }
#  }
#}

data "http" "myip" {
  url = "http://ifconfig.me"
}

//output "terraform_state" {
//  value = data.terraform_remote_state.vpc
//}
//
//data "aws_subnet"  "public" {
//  filter {
//    name = "vpc-id"
//    values = [data.aws_vpc.vpc.id]
//  }
//  filter {
//    name   = "tag:Name"
//    values = [format("%s-public-*",var.tag_name )]
//  }
//}
//
//data "aws_subnet"  "database" {
//  filter {
//    name = "vpc-id"
//    values = [data.aws_vpc.vpc.id]
//  }
//  filter {
//    name   = "tag:Name"
//    values = [format("%s-database-*",var.tag_name )]
//  }
//}