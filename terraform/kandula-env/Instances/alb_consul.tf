resource "aws_lb" "ops_lb" {
  count = var.create_lb ? 1: 0
  name            = "${var.tag_name}-ops-lb"
  subnets         = data.terraform_remote_state.vpc.outputs.public_subnets[*].id #var.public_subnet_ids
  security_groups = [aws_security_group.consul_lb_sg.id,aws_security_group.elk_alb_security_group.id,aws_security_group.jenkins_lb_sg.id]
  load_balancer_type = "application"
  enable_cross_zone_load_balancing = true
}
# sg_lb includes:
#   port 80 open to 0.0.0.0/0
#sg_consul servers
#      port 8500 to sg_lb

#sg_common
# 22 to sg_common
# 8300-8301 to sg_common

# Create a Listener
resource "aws_alb_listener" "consul-alb-listener" {
  count = var.create_lb ? 1: 0
  default_action {
    target_group_arn = aws_alb_target_group.consul-target-group[0].arn
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  #  default_action {
  #    target_group_arn = aws_lb_target_group.consul-target-group[0].arn
  #    type = "forward"
  #  }
  ###load_balancer_arn = var.lb_arn[0]
  load_balancer_arn = aws_lb.ops_lb[0].arn
  port = 80
  ##  port = 8500
  protocol = "HTTP"
}

resource "aws_alb_listener" "ops_https_alb" {
  count = var.create_lb ? 1: 0
  load_balancer_arn = aws_lb.ops_lb[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.consul-target-group[0].arn
  }
}


resource "aws_lb_listener_rule" "consul_443" {
  listener_arn = aws_alb_listener.ops_https_alb[0].arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.consul-target-group[0].arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    host_header {
      values = ["consul.*"]
    }
  }
}

resource "aws_alb_target_group" "consul-target-group" {
  count = var.create_lb ? 1: 0
  name = "${var.tag_name}-consul-tg"
  target_type = "instance"
  port = 8500
  protocol = "HTTP"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    enabled = true
    path    = "/ui/"
  }
}

# register target to LB

resource "aws_lb_target_group_attachment" "consul_target_att" {
  count = var.create_lb ? var.consul_instance_count : 0
  target_group_arn = aws_alb_target_group.consul-target-group[0].arn
  target_id        = module.consul.consul_servers_ids[count.index] #aws_instance.consul[count.index].id
  port             = 8500

}


