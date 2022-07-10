resource "aws_security_group" "jenkins_lb_sg" {
  name = format("%s", "${var.tag_name}_jenkins_lb_sg")
  description = "security group for load balancers of jenkins"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_security_group_rule" "ui_access" {
    from_port   = 8080
    to_port     = 8080
    protocol = "tcp"
    type= "ingress"
    security_group_id = module.jenkins_server.jenkins_server_sg
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

resource "aws_lb" "jenkins_lb" {
  count = var.create_lb ? 1: 0
  name            = "${var.tag_name}-jenkins-lb"
  subnets         = data.terraform_remote_state.vpc.outputs.public_subnets[*].id
  security_groups = [aws_security_group.jenkins_lb_sg.id ]
  load_balancer_type = "application"
  enable_cross_zone_load_balancing = true
}


# Create a Listener
resource "aws_lb_listener" "jenkins-alb-listener" {
  count = var.create_lb ? 1: 0
  #default_action {
  #  target_group_arn = aws_lb_target_group.jenkins_target-group.arn
  #  type = "forward"
  #}
  default_action {
    target_group_arn = aws_lb_target_group.jenkins_target-group.arn
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  load_balancer_arn = aws_lb.jenkins_lb[0].arn
  port = 8080
  protocol = "HTTP"
}


resource "aws_lb_target_group" "jenkins_target-group" {
  name = "${var.tag_name}-jenkins-tg"
  port = 8080
  protocol = "HTTP"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path = "/login"
    port = 8080
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

resource "aws_alb_listener" "jenkins_https_alb" {
  count = var.create_lb ? 1: 0
  load_balancer_arn = aws_lb.jenkins_lb[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_target-group.arn
  }
}

# register target to LB

resource "aws_lb_target_group_attachment" "target_att" {
  target_group_arn = aws_lb_target_group.jenkins_target-group.arn
  target_id        = module.jenkins_server.jenkins_servers_id
  port             = 8080
}
locals {
  subnets=data.terraform_remote_state.vpc.outputs.private_subnets[0].id
}