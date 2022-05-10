resource "aws_security_group" "common" {
  name = var.security_group_common
  description = "security group for all servers"
  vpc_id = aws_vpc.vpc.id
    lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group_rule" "common_ssh_access" {
    from_port   = 22
    to_port     = 22
    protocol = "tcp"
    type= "ingress"
    security_group_id = aws_security_group.common.id
    self = true
    description = "Allow ssh access in vpc"
}

resource "aws_security_group_rule" "common_ping" {
    from_port   = 8
    to_port     = 0
    protocol = "icmp"
    type= "ingress"
    security_group_id = aws_security_group.common.id
    self = true
    description = "Allow ping "
}

resource "aws_security_group_rule" "common_out" {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    type= "egress"
    security_group_id = aws_security_group.common.id
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access out "
}