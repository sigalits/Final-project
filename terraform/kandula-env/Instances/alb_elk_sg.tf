#elk-consul-alb

resource "aws_security_group" "elk_alb_security_group" {
      name = "elk_consul_alb_security_group"
      vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
      tags = {
        Name = format("%s-alb_elk_sg", var.tag_name )
      }
  }

resource "aws_security_group_rule" "alb_elk_ui_access" {
    description       = "Allow kibana UI access from the world"
    from_port         = 5601
    to_port           = 5601
    protocol          = "tcp"
    security_group_id = aws_security_group.elk_alb_security_group.id
    type              = "ingress"
    cidr_blocks       = concat([var.vpc_cidr],["${data.http.myip.body}/32"])
}

resource "aws_security_group_rule" "alb_elk_ui_access_80" {
    description       = "Allow kibana UI access from the world 0n port 80"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.elk_alb_security_group.id
    type              = "ingress"
    cidr_blocks       = concat([var.vpc_cidr],["${data.http.myip.body}/32"])
}

resource "aws_security_group_rule" "elk_alb_inside_all" {
    description       = "Allow all inside security group"
    from_port         = 0
    protocol           = "-1"
    security_group_id = aws_security_group.elk_alb_security_group.id
    to_port           = 0
    type              = "ingress"
    self              = true
}

resource "aws_security_group_rule" "elk_consul_alb_outbound_anywhere" {
    description       = "allow outbound traffic to anywhere"
    from_port         = 0
    protocol           = "-1"
    security_group_id = aws_security_group.elk_alb_security_group.id
    to_port           = 0
    type              = "egress"
    cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elk_consul_alb_https_access" {
    description       = "allow https access from my ip"
    from_port         = 443
    protocol          = "tcp"
    security_group_id = aws_security_group.elk_alb_security_group.id
    to_port           = 443
    type              = "ingress"
    cidr_blocks       = concat([var.vpc_cidr],["${data.http.myip.body}/32"])
}


resource "aws_security_group_rule" "alb_elk_in_access_5601" {
    from_port   = 5601
    to_port     = 5601
    protocol = "tcp"
    type= "ingress"
    security_group_id = aws_security_group.elk_sg.id
    source_security_group_id    =  aws_security_group.elk_alb_security_group.id # module.consul.elk_alb_sg_id
    description = "open elk ui on port 5601"
}

resource "aws_security_group_rule" "alb_elk_ui_access_out_5601" {
    from_port   = 5601
    to_port     = 5601
    protocol = "tcp"
    type= "egress"
    self = true
    security_group_id = aws_security_group.elk_alb_security_group.id #module.consul.elk_alb_sg_id
    description = "open elk ui out port 5601"
}

resource "aws_security_group_rule" "alb_elk_ui_access_out_443" {
    from_port   = 443
    to_port     = 443
    protocol = "tcp"
    type= "egress"
    security_group_id = aws_security_group.elk_alb_security_group.id #module.consul.elk_alb_sg_id
    source_security_group_id    = aws_security_group.elk_sg.id
    description = "open elk ui out port 443"
}

resource "aws_security_group_rule" "alb_elk_ui_access_out_80" {
    from_port   = 80
    to_port     = 80
    protocol = "tcp"
    type= "egress"
    security_group_id = aws_security_group.elk_alb_security_group.id # module.consul.elk_alb_sg_id
    source_security_group_id    = aws_security_group.elk_sg.id
    description = "open elk ui out port 80"
}