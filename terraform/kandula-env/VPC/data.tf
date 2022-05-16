data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "jenkins-ami" {
  most_recent = true
  owners      = ["797686858489"]

  filter {
    name   = "name"
    values = ["jenkins-master*"]
  }
}
