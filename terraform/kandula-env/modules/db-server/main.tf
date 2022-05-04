#Create security group for database servers
resource "aws_security_group" "db_sg" {
  name = var.security_group_database
  description = "security group for databases"
  vpc_id = var.vpc_id
}

 resource "aws_security_group_rule" "pg_access" {
    from_port   = 5432
    to_port     = 5432
    protocol = "tcp"
    type= "ingress"
    security_group_id = aws_security_group.db_sg.id
    cidr_blocks = concat(var.cidr_blocks,["${var.vpc_cidr}"])
    description = "Allow postgres port"
}

#resource "aws_security_group_rule" "pg_access" {
#    from_port   = 5432
#    to_port     = 5432
#    protocol = "tcp"
#    type= "ingress"
#    security_group_id = aws_security_group.this.id
#    cidr_blocks = [var.vpc_cidr]
#    description = "Allow postgress in vpc"
#}

resource "aws_security_group_rule" "db_ssh_access" {
    from_port   = 22
    to_port     = 22
    protocol = "tcp"
    type= "ingress"
    security_group_id = aws_security_group.db_sg.id
    cidr_blocks = [var.vpc_cidr]
    description = "Allow ssh access in vpx"
}

resource "aws_security_group_rule" "db_ping" {
    from_port   = 8
    to_port     = 0
    protocol = "icmp"
    type= "ingress"
    security_group_id = aws_security_group.db_sg.id
    cidr_blocks = var.cidr_blocks
    description = "Allow ping "
}

resource "aws_security_group_rule" "db_out" {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    type= "egress"
    security_group_id = aws_security_group.db_sg.id
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access out "
}




resource "aws_instance" "db" {
  count = var.create_dbservers ? var.db_instance_count: 0
  ami = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  associate_public_ip_address = "false"
  vpc_security_group_ids = [ aws_security_group.db_sg.id]
  subnet_id = var.subnet_ids[count.index]
  user_data = file("${path.module}/user_data_db.sh")
  tags = {
    "Name" = "${var.tag_name}_${count.index}"
  }
}

#resource "aws_ebs_volume" "vol2" {
#  count = var.db_instance_count
#  size = var.ebs_data_size
#  type = var.ebs_data_type
#  encrypted = "true"
#  tags = {
#    name = "${var.tag_name}-ebs-${count.index}"
#  }
#  availability_zone = var.az[count.index]
#}
#
#resource "aws_volume_attachment" "ebs_att" {
#  count = var.db_instance_count
#  device_name = "/dev/sdh"
#  volume_id   = aws_ebs_volume.vol2[count.index].id
#  instance_id = aws_instance.this[count.index].id
#}
