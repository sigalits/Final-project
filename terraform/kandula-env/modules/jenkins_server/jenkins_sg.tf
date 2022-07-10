#jenkins
resource "aws_security_group" "jenkins_server" {
  name = "jenkins_server_sg"
  description = "Allow Jenkins inbound traffic"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "jenkins_8080_access" {
    description       = "allow 8080 access from anywhere"
    from_port         = 8080
    protocol          = "tcp"
    security_group_id = aws_security_group.jenkins_server.id
    to_port           = 8080
    type              = "ingress"
    self              = true
}

resource "aws_security_group_rule" "jenkins_server_anywhere" {
    description       = "allow outbound traffic to anywhere"
    from_port         = 0
    protocol           = "-1"
    security_group_id = aws_security_group.jenkins_server.id
    to_port           = 0
    type              = "egress"
    cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "jenkins_inside_all" {
    description       = "Allow all inside security group"
    from_port         = 0
    protocol           = "-1"
    security_group_id = aws_security_group.jenkins_server.id
    to_port           = 0
    type              = "ingress"
    self              = true
}
