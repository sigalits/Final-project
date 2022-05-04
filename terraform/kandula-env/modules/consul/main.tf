#Create security group for database servers
resource "aws_security_group" "consul" {
  name = var.security_group_consul
  description = "security group for databases"
  vpc_id = var.vpc_id
}
# TODO: move to VPC common sg
resource "aws_security_group" "common" {
  name = var.security_group_common
  description = "security group for all servers"
  vpc_id = var.vpc_id
}
resource "aws_security_group" "consul_lb_sg" {
  name = var.security_group_consul_lb
  description = "security group for load balancers of consul"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ui_access" {
    from_port   = 8500
    to_port     = 8500
    protocol = "tcp"
    type= "ingress"
    security_group_id = aws_security_group.consul.id
    source_security_group_id = aws_security_group.consul_lb_sg.id
    description = "Allow ui port"
}
resource "aws_security_group_rule" "ui_access_out" {
    from_port   = 8500
    to_port     = 8500
    protocol = "tcp"
    type= "egress"
    security_group_id = aws_security_group.consul_lb_sg.id
    self = true
    description = "open ui out port"
}

resource "aws_security_group_rule" "consul_internal_access" {
    from_port   = 8300
    to_port     = 8301
    protocol = -1
    type= "ingress"
    security_group_id = aws_security_group.common.id
    self = true
    description = "Allow internal consul ports"
}

resource "aws_security_group_rule" "consul_ssh_access" {
    from_port   = 22
    to_port     = 22
    protocol = "tcp"
    type= "ingress"
    security_group_id = aws_security_group.common.id
    self = true
    description = "Allow ssh access in vpc"
}

resource "aws_security_group_rule" "consul_ping" {
    from_port   = 8
    to_port     = 0
    protocol = "icmp"
    type= "ingress"
    security_group_id = aws_security_group.common.id
    self = true
    description = "Allow ping "
}

resource "aws_security_group_rule" "consul_out" {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    type= "egress"
    security_group_id = aws_security_group.common.id
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access out "
}

resource "aws_security_group_rule" "lb_incomming" {
    from_port   = 80
    to_port     = 80
    protocol = "tcp"
    type= "ingress"
    security_group_id = aws_security_group.consul_lb_sg.id
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access out "
}

resource "aws_instance" "consul" {
  count = var.create_consul_servers ? var.consul_instance_count: 0
  ami = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  associate_public_ip_address = false
  vpc_security_group_ids = [ aws_security_group.consul.id , aws_security_group.common.id ,aws_security_group.consul_lb_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.consul-join.name
  subnet_id = element(var.subnet_ids,count.index)
  #user_data = file("${path.module}/user_data_db.sh")
  tags = {
    "Name" = "${var.tag_name}_${count.index}"
    "consul_server" = "true"
  }
}


# Create an IAM role for the auto-join
resource "aws_iam_role" "consul-join" {
  name               = "${var.tag_name}-consul-join"
  assume_role_policy = var.assume_role_policy
}

# Create the policy
resource "aws_iam_policy" "consul-join" {
  name        = "${var.tag_name}-consul-join"
  description = "Allows Consul nodes to describe instances for joining."
  policy      = var.describe_instances_policy
}

# Attach the policy
resource "aws_iam_policy_attachment" "consul-join" {
  name       = "${var.tag_name}-consul-join"
  roles      = [aws_iam_role.consul-join.name]
  policy_arn = aws_iam_policy.consul-join.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "consul-join" {
  name = "${var.tag_name}-consul-join"
  role = aws_iam_role.consul-join.name
}


output "consul-join-iam-role" {
  description = "arn for consul-join iam role"
  value       = aws_iam_role.consul-join.arn
}

