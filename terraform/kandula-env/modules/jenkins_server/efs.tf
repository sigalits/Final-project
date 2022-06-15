resource "aws_security_group" "efs" {
   name_prefix	= "jenkins-master-efs-sg-"
   description= "Allows inbound efs traffic from vpc"
   vpc_id = var.vpc_id

   ingress {
     security_groups = [aws_security_group.jenkins_server.id]
     self = true
     from_port = 2049
     to_port = 2049
     protocol = "tcp"
   }

   egress {
     #security_groups = [aws_security_group.ec2.id]
     self = true
     from_port = 0
     to_port = 0
     protocol = "-1"
   }
  tags = { "Name" = "${var.tag_name}-jenkins-master-efs-sg" }

 }




resource "aws_efs_mount_target" "jenkins_volume_efs_mount" {
   file_system_id  = var.efs_id
   subnet_id = var.subnet_id
   security_groups = [aws_security_group.efs.id]
 }

