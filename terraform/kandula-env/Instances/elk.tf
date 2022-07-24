# ---------------------------------------------------------------------------------------------------------------------
# security group
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "elk_sg" {
  name        = "elk-sg"
  description = "SG for ELK"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  tags = {
    Name = format("%s-elk-sg", var.tag_name)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elasticsearch_rest_tcp" {
  type              = "ingress"
  from_port         = 9200
  to_port           = 9200
  protocol          = "tcp"
  self              = true
  description       = "Allow elk rest tcp"
  security_group_id = aws_security_group.elk_sg.id
}

resource "aws_security_group_rule" "elasticsearch_java_tcp" {
  type              = "ingress"
  from_port         = 9300
  to_port           = 9300
  protocol          = "tcp"
  self              = true
  description       = "Allow elk java tcp"
  security_group_id = aws_security_group.elk_sg.id
}


resource "aws_security_group_rule" "kibana_tcp" {
  type              = "ingress"
  from_port         = 5601
  to_port           = 5601
  protocol          = "tcp"
  self              = true
  description       = "Allow kibana ui"
  security_group_id = aws_security_group.elk_sg.id
}

# ---------------------------------------------------------------------------------------------------------------------
# ec2
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "elk" {
  count = var.create_elk ? 1: 0
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = var.elk_instance_type
  key_name                    = var.key_name
  iam_instance_profile        = module.consul.consul_iam_instance_profile_name
  subnet_id                   = data.terraform_remote_state.vpc.outputs.private_subnets[0].id
  associate_public_ip_address = false
  user_data = file("${path.module}/../templates/userdata_eks.sh")

  vpc_security_group_ids = [
    data.terraform_remote_state.vpc.outputs.common_sg_id,aws_security_group.elk_sg.id
  ]

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name                = format("%s-elk", var.tag_name)
    elk_server          = "true"
    consul_agent = "true"
    node_exporter = "true"
    filebeat = "true"
  }
}


