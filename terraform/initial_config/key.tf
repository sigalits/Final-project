## SSH
resource "tls_private_key" "project_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "project_key" {
  key_name   = var.key_name
  public_key = tls_private_key.project_key.public_key_openssh
}

#resource "null_resource" "chmod_400_key" {
#  provisioner "local-exec" {
#    command = "chmod 0400 ${path.module}/${local_sensitive_file.private_key.filename}"
#  }
#}

resource "local_sensitive_file" "private_key" {
  content = tls_private_key.project_key.private_key_pem
  filename          = var.pem_key_file_name
}

resource "null_resource" "chmod_400_key" {
  provisioner "local-exec" {
    command = "attrib +r ${path.module}/${local_sensitive_file.private_key.filename}"
  }
}