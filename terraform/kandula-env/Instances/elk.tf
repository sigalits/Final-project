# ---------------------------------------------------------------------------------------------------------------------
# security group
# ---------------------------------------------------------------------------------------------------------------------
module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.17.0"

  name   = "${var.tag_name}-elk"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  #ingress_cidr_blocks = ["${data.http.myip.body}/32"]
#  ingress_rules = [
#    "elasticsearch-rest-tcp",
#    "elasticsearch-java-tcp",
#    "kibana-tcp",
#    "logstash-tcp",
#    "ssh-tcp"
#  ]
  ingress_with_self = [{ rule = "all-all" }]
  egress_rules      = ["all-all"]

}

# ---------------------------------------------------------------------------------------------------------------------
# ec2
# ---------------------------------------------------------------------------------------------------------------------
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.16.0"

  instance_count              = var.elk_instance_count
  name                        = "${var.tag_name}-elk"
  instance_type               = "t3.medium"
  ami                         = data.aws_ami.ubuntu-18.id
  key_name                    = var.key_name
  subnet_id                   = data.terraform_remote_state.vpc.outputs.private_subnets[0].id
  vpc_security_group_ids      = [module.security-group.this_security_group_id,data.terraform_remote_state.vpc.outputs.common_sg_id ]
  associate_public_ip_address = false
  user_data = file("${path.module}/../templates/userdata_eks.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

