resource "aws_instance" "jenkins" {
  ami = var.ami_id
  private_ip = var.private_ip
  key_name = var.key_name
  instance_type = var.instance_type
  associate_public_ip_address = false
  vpc_security_group_ids = [ aws_security_group.jenkins_server.id ,aws_security_group.jenkins_lb_sg.id, var.common_sg]
  iam_instance_profile   = aws_iam_instance_profile.jenkins-master-profile.name
  subnet_id = var.subnet_id
  user_data = templatefile("${path.module}/../../templates/user_data_jenkins_master.sh" , {
      region = var.aws_region,
      efs_dns = var.efs_dns
  })
  tags = {
    Name = "jenkins-server"
    consul_agent: "true"
    purpose: "jenkins"
  }
}






