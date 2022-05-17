resource "aws_instance" "jenkins" {
  ami = var.ami_id
  private_ip = var.private_ip
  key_name = var.key_name
  instance_type = var.instance_type
  associate_public_ip_address = false
  vpc_security_group_ids = [ var.jenkins_sg ,var.common_sg ,var.jenkins_lb_sg]
  iam_instance_profile   = var.iam_instance_profile
  subnet_id = var.subnet_id
  #user_data = file("${path.module}/user_data_db.sh")
  tags = {
    Name = "jenkins-server"
    consul_agent: "true"
    purpose: "jenkins"
  }
}






