output "bastion_servers_private_ips" {
  value = aws_instance.bastion[*].private_ip
}
output "bastion_servers_public_ips" {
  value = aws_instance.bastion[*].public_ip
}
output "bastion_servers_ids" {
  value = aws_instance.bastion[*].id
}

output  "bastion_server" {
  value = aws_instance.bastion
}