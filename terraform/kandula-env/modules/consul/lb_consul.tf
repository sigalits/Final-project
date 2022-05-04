resource "aws_lb" "consul_lb" {
  count = var.create_consul_lb ? 1: 0
  name            = "${var.tag_name}-lb"
  subnets         = var.public_subnet_ids
  security_groups = [aws_security_group.consul_lb_sg.id]
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
resource "aws_lb_listener" "consul-alb-listener" {
  count = var.create_consul_lb ? 1: 0
  default_action {
    target_group_arn = aws_lb_target_group.consul-target-group[0].arn
    type = "forward"
  }
  load_balancer_arn = aws_lb.consul_lb[0].arn
  port = 80
  protocol = "HTTP"
}


resource "aws_lb_target_group" "consul-target-group" {
  count = var.create_consul_lb ? 1: 0
  name = "${var.tag_name}-tg"
  port = 8500
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    enabled = true
    path    = "/ui/"
  }
    tags = {
    "name" = "${var.tag_name}-target-group-consul"
  }
}

# restister targset to LB

resource "aws_lb_target_group_attachment" "consul_target_att" {
  count = var.create_consul_lb ? var.consul_instance_count : 0
  target_group_arn = aws_lb_target_group.consul-target-group[0].arn
  target_id        = aws_instance.consul[count.index].id
  port             = 8500

}


