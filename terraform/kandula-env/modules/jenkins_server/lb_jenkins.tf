resource "aws_lb" "lb" {
  name            = "${var.tag_name}-jenkins-lb"
  subnets         = var.public_subnet_ids
  security_groups = [var.jenkins_lb_sg ]
  load_balancer_type = "application"
  enable_cross_zone_load_balancing = true
}

# Create a Listener
resource "aws_lb_listener" "jenkins-alb-listener" {
  default_action {
    target_group_arn = aws_lb_target_group.jenkins_target-group.arn
    type = "forward"
  }
  load_balancer_arn = aws_lb.lb.arn
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

# register targset to LB

resource "aws_lb_target_group_attachment" "target_att" {
  target_group_arn = aws_lb_target_group.jenkins_target-group.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}
locals {
  subnets=var.subnet_id
}


