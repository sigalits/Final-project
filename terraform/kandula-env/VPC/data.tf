data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "jenkins-ami" {
  most_recent = true
  owners      = ["797686858489"]

  filter {
    name   = "name"
    values = ["jenkins-master*v6"]
  }
}


#data "aws_route53_zone" "MyZone" {
#    name = var.domain_name
#}

data "aws_route53_zone" "selected" {
  name         = "${var.domain_name}."
  private_zone = false
}



