
resource "aws_alb_target_group" "elk-group" {
  name = "alb-elk-target-group"
  port = 5601
  protocol = "HTTP"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  target_type = "instance"
  health_check {
   enabled = true
    path = "/"
    matcher = "200,302"
  }
    tags = {
       Name = format("%s-alb_elk_sg", var.tag_name )
    }

  stickiness {
    type = "lb_cookie"
    cookie_duration = 60
  }
}


resource "aws_alb_target_group_attachment" "elk_server" {
  count = var.create_elk ? 1: 0
  target_group_arn = aws_alb_target_group.elk-group.arn
  target_id        = aws_instance.elk[0].id
  port             = 5601
}

resource "aws_lb_listener_rule" "elk_443" {
  listener_arn = aws_alb_listener.ops_https_alb[0].arn #module.consul.listener_consul_https_alb_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.elk-group.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    host_header {
      values = ["kibana.*"]
    }
  }
}

