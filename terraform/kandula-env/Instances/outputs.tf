output "ec2_private_ip_kandula_instance" {
  value = module.web-server.kandula_private_ips[*]
}

output "ec2_public_ip_kandula_instance" {
  value = module.web-server.kandula_public_ips[*]
}

output "ec2_private_ip_database_instance" {
  value = module.database.database_servers_ips[*]
}

output "ec2_private_ip_consul_instance" {
  value = module.consul.consul_servers_ips[*]
}

output "ec2_private_ip_bastion_server" {
  value = module.bastion.bastion_servers_private_ips[*]
}

output "ec2_public_ip_bastion_server" {
  value = module.bastion.bastion_servers_public_ips[*]
}

output "Used_Availability_Zones" {
  value = local.azs
}

