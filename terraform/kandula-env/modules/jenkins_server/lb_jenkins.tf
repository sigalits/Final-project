resource "aws_lb" "lb" {
  count = var.create_lb ? 1: 0
  name            = "${var.tag_name}-jenkins-lb"
  subnets         = var.public_subnet_ids
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
  load_balancer_arn = aws_lb.lb[0].arn
  port = 8080
  protocol = "HTTP"
}


resource "aws_lb_target_group" "jenkins_target-group" {
  name = "${var.tag_name}-jenkins-tg"
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    path = "/"
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
  load_balancer_arn = aws_lb.lb[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.aws_acm_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_target-group.arn
  }
}

# register target to LB

resource "aws_lb_target_group_attachment" "target_att" {
  target_group_arn = aws_lb_target_group.jenkins_target-group.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}
locals {
  subnets=var.subnet_id
}


