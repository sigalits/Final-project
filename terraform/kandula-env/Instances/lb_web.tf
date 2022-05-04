resource "aws_lb" "lb_web" {
  count = var.create_lb ? 1: 0
  name            = "${var.tag_name}-web"
  subnets         = [data.terraform_remote_state.vpc.outputs.public_subnets[*].id]
  security_groups = [data.terraform_remote_state.vpc.outputs.kandula_sg]
  load_balancer_type = "application"
  enable_cross_zone_load_balancing = true
}

# Create a Listener
resource "aws_lb_listener" "web-alb-listener" {
  count = var.create_lb ? 1: 0
  default_action {
    target_group_arn = aws_lb_target_group.web_target-group[0].arn
    type = "forward"
  }
  load_balancer_arn = aws_lb.lb_web[0].arn
  port = 80
  protocol = "HTTP"
}


resource "aws_lb_target_group" "web_target-group" {
  count = var.create_lb ? 1: 0
  name = "${var.tag_name}-web-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.vpc.id
  stickiness {
      type = "lb_cookie"
      cookie_duration = 60
  }
  health_check {
    enabled = true
    path    = "/"
  }
    tags = {
    "name" = "${var.tag_name}-target-group-web"
  }
}

# restister targset to LB

resource "aws_lb_target_group_attachment" "target_att" {
  count = var.create_lb ? length(local.azs) : 0
  target_group_arn = aws_lb_target_group.web_target-group[0].arn
  target_id        = module.web-server.kandula_web_server[count.index].id
  port             = 80
}
locals {
  subnets=[data.terraform_remote_state.vpc.outputs.public_subnets[*].id]
}


