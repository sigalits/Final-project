output "kandula_public_ips" {
  value = aws_instance.kandula[*].public_ip
}

output "kandula_private_ips" {
  value = aws_instance.kandula[*].private_ip
}

output "kandula_sg_id" {
  value =var.security_group_kandula
}

output "kandula_ids" {
  value = aws_instance.kandula[*].id
}

output  "kandula_web_server" {
  value = aws_instance.kandula
}