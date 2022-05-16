resource "aws_s3_bucket" "backup_bucket" {
    bucket = lower(var.jenkins_bucket_name)
    acl = var.acl_value
  #  force_destroy = var.force_destroy
  tags = {"Name" = var.jenkins_bucket_name}
 }


#jenkins
resource "aws_security_group" "jenkins_server" {
  name = "jenkins_server_sg"
  description = "Allow Jenkins inbound traffic"
  vpc_id = module.vpc.vpc_id
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



resource "aws_security_group" "jenkins_lb_sg" {
  name = format("%s", "${var.tag_name}_jenkins_lb_sg")
  description = "security group for load balancers of jenkins"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ui_access" {
    from_port   = 8080
    to_port     = 8080
    protocol = "tcp"
    type= "ingress"
    security_group_id = aws_security_group.jenkins_server.id
    source_security_group_id = aws_security_group.jenkins_lb_sg.id
    description = "Allow ui port to jenkins servers"
}
resource "aws_security_group_rule" "ui_access_out" {
    from_port   = 8080
    to_port     = 8080
    protocol = "tcp"
    type= "egress"
    security_group_id = aws_security_group.jenkins_lb_sg.id
    self = true
    description = "open ui out port"
}


resource "aws_security_group_rule" "jenkins_lb_incomming" {
    from_port   = 8080
    to_port     = 8080
    protocol = "tcp"
    type= "ingress"
    security_group_id = aws_security_group.jenkins_lb_sg.id
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access out "
}