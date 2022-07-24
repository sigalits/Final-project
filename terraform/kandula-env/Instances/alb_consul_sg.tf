resource "aws_security_group" "consul_lb_sg" {
  name = var.security_group_consul_lb
  description = "security group for load balancers of consul"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_security_group_rule" "ui_access" {
    from_port   = 8500
    to_port     = 8500
    protocol = "tcp"
    type= "ingress"
    security_group_id = module.consul.consul_sg_id  #aws_security_group.consul.id
    source_security_group_id = aws_security_group.consul_lb_sg.id
    description = "Allow ui port"
}


resource "aws_security_group_rule" "ui_access_out" {
    from_port   = 8500
    to_port     = 8500
    protocol = "tcp"
    type= "egress"
    ##security_group_id = var.lb_sg_id
    security_group_id = aws_security_group.consul_lb_sg.id
    self = true
    description = "open ui out port"
}


resource "aws_security_group_rule" "lb_incomming" {
    from_port   = 80
    to_port     = 80
    protocol = "tcp"
    type= "ingress"
    ##security_group_id = var.lb_sg_id
    security_group_id = aws_security_group.consul_lb_sg.id
    cidr_blocks = concat([var.vpc_cidr],["${data.http.myip.body}/32"])
    description = "Allow access from outside on 80 "
}

resource "aws_security_group_rule" "lb_incomming_443" {
    from_port   = 443
    to_port     = 443
    protocol = "tcp"
    type= "ingress"
    ##security_group_id = var.lb_sg_id
    security_group_id = aws_security_group.consul_lb_sg.id
    cidr_blocks = concat([var.vpc_cidr],["${data.http.myip.body}/32"])
    description = "Allow access from outside on 443 "
}
