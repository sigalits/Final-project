resource "aws_security_group" "jenkins_lb_sg" {
  name = format("%s", "${var.tag_name}_jenkins_lb_sg")
  description = "security group for load balancers of jenkins"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_security_group_rule" "jenkins_ui_access" {
    from_port   = 8080
    to_port     = 8080
    protocol = "tcp"
    type= "ingress"
    security_group_id = module.jenkins_server.jenkins_server_sg
    source_security_group_id = aws_security_group.jenkins_lb_sg.id
    description = "Allow ui port to jenkins servers"
}
resource "aws_security_group_rule" "jenkins_ui_access_out" {
    from_port   = 8080
    to_port     = 8080
    protocol = "tcp"
    type= "egress"
    security_group_id = aws_security_group.jenkins_lb_sg.id
    self = true
    description = "open ui outbound port 8080 in vpc "
}


resource "aws_security_group_rule" "jenkins_lb_incomming" {
    from_port   = 8080
    to_port     = 8080
    protocol = "tcp"
    type= "ingress"
    security_group_id = aws_security_group.jenkins_lb_sg.id
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access from out on 8080"
}

resource "aws_security_group_rule" "jenkins_alb_https_all" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_lb_sg.id
  description = "Allow access from out on 443"
}
