output "monitoring_public_ips" {
  value = aws_instance.monitoring[*].public_ip
}

output "monitoring_private_ips" {
  value = aws_instance.monitoring[*].private_ip
}

output "monitoring_sg" {
  value =aws_security_group.monitor_sg.id
}

output "monitoring_instance_ids" {
  value = aws_instance.monitoring[*].id
}

output  "monitoring_server" {
  value = aws_instance.monitoring
}