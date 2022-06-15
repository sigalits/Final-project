resource "aws_efs_file_system" "jenkins_volume_efs" {
  creation_token = "jenkins-master-efs"
  encrypted = true

  tags = {"Name" = "jenkins-master-efs"}
  }