output "database_servers_ips" {
  value = aws_instance.db[*].private_ip
}
output "database_servers_ids" {
  value = aws_instance.db[*].id
}

output  "db_server" {
  value = aws_instance.db
}