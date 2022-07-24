#resource "aws_lb" "jenkins_lb" {
#  count = var.create_lb ? 1: 0
#  name            = "${var.tag_name}-jenkins-lb"
#  subnets         = data.terraform_remote_state.vpc.outputs.public_subnets[*].id
#  security_groups = [aws_security_group.jenkins_lb_sg.id ]
#  load_balancer_type = "application"
#  enable_cross_zone_load_balancing = true
#}


# Create a Listener
#resource "aws_lb_listener" "jenkins-alb-listener" {
#  count = var.create_lb ? 1: 0
#  default_action {
#    target_group_arn = aws_lb_target_group.jenkins_target-group.arn
#    type = "redirect"
#
#    redirect {
#      port        = "443"
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#  load_balancer_arn = aws_lb.jenkins_lb[0].arn
#  port = 8080
#  protocol = "HTTP"
#}
#
#
#resource "aws_lb_target_group" "jenkins_target-group" {
#  name = "${var.tag_name}-jenkins-tg"
#  port = 8080
#  protocol = "HTTP"
#  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
#  health_check {
#    path = "/login"
#    port = 8080
#    healthy_threshold = 3
#    unhealthy_threshold = 2
#    timeout = 2
#    interval = 5
#    matcher = "200"  # has to be HTTP 200 or fails
#  }
#}
#
#resource "aws_alb_listener" "jenkins_https_alb" {
#  count = var.create_lb ? 1: 0
#  load_balancer_arn = aws_lb.jenkins_lb[0].arn
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = aws_acm_certificate.cert.arn
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.jenkins_target-group.arn
#  }
#}
#
## register target to LB
#
#resource "aws_lb_target_group_attachment" "target_att" {
#  target_group_arn = aws_lb_target_group.jenkins_target-group.arn
#  target_id        = module.jenkins_server.jenkins_servers_id
#  port             = 8080
#}
#locals {
#  subnets=data.terraform_remote_state.vpc.outputs.private_subnets[0].id
#}


################new ALB####



resource "aws_alb_target_group" "jenkins-tg" {
  name = "jenkins-target-group"
  port = 8080
  protocol = "HTTP"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  target_type = "instance"
  health_check {
   enabled = true
    path = "/login"
    matcher = "200,302"
  }
    tags = {
       Name = format("%s-alb_jenkins_sg", var.tag_name )
    }

  stickiness {
    type = "lb_cookie"
    cookie_duration = 60
  }
}


resource "aws_alb_target_group_attachment" "jenkins_server" {
  target_group_arn = aws_alb_target_group.jenkins-tg.arn
  target_id        = module.jenkins_server.jenkins_servers_id
  port             = 8080
}

resource "aws_lb_listener_rule" "jenkins_443" {
  listener_arn = aws_alb_listener.ops_https_alb[0].arn #module.consul.listener_consul_https_alb_arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.jenkins-tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    host_header {
      values = ["jenkins.*"]
    }
  }
}


