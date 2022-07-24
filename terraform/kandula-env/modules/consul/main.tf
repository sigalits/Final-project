#Create security group for database servers
resource "aws_security_group" "consul" {
  name = var.security_group_consul
  description = "security group for consul servers"
  vpc_id = var.vpc_id
}




resource "aws_instance" "consul" {
  count = var.create_consul_servers ? var.consul_instance_count: 0
  ami = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  associate_public_ip_address = false
  #vpc_security_group_ids = [aws_security_group.consul.id , var.common_sg_id ,aws_security_group.consul_lb_sg.id]
  vpc_security_group_ids = [aws_security_group.consul.id , var.common_sg_id , var.consul_lb_sg_id ,var.consul_lb_sg_id ]
  iam_instance_profile   = aws_iam_instance_profile.consul-join.name
  subnet_id = element(var.subnet_ids,count.index)
  #user_data = file("${path.module}/user_data_db.sh")
  tags = {
    "Name" = "${var.tag_name}_${count.index}"
    "consul_server"  = "true"
    "node_exporter"  = "true"
    "filebeat"       = "true"
  }
}






