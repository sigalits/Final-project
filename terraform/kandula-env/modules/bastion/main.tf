#Create security group for database servers
resource "aws_security_group" "bastion" {
  name = var.security_group_bastion
  description = "security group for databases"
  vpc_id = var.vpc_id
    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "bastion_ssh_access" {
    from_port   = 22
    to_port     = 22
    protocol = "tcp"
    type= "ingress"
    security_group_id = aws_security_group.bastion.id
    cidr_blocks = var.cidr_blocks
    description = "Allow ssh access in vpx"
}

resource "aws_security_group_rule" "bastion_ping" {
    from_port   = 8
    to_port     = 0
    protocol = "icmp"
    type= "ingress"
    security_group_id = aws_security_group.bastion.id
    cidr_blocks = var.cidr_blocks
    description = "Allow ping "
}

resource "aws_security_group_rule" "bastion_out" {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    type= "egress"
    security_group_id = aws_security_group.bastion.id
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access out "
}


resource "aws_instance" "bastion" {
  ami = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.bastion.id ,var.common_security_group_id]
  subnet_id = var.subnet_ids[0]
  iam_instance_profile   = var.attach_instance_profile
  #user_data = file("${path.module}/user_data_db.sh")
  tags = {
    "Name" = "${var.tag_name}"
    "bastion_server" = "true"
    "consul_agent"   = "true"
    "node_exporter"  = "true"
    "filebeat"       = "true"
    "psql" = var.create_rds ? "true" : "false"
  }
    metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
  }

}

resource "aws_route53_record" "bastion_record" {
  zone_id = var.r53_zone_id
  name    = "bastion"
  type    = "A"
  ttl =  60
  records = [aws_instance.bastion.public_ip]
}