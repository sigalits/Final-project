output "consul_servers_ips" {
  value = aws_instance.consul[*].private_ip
}
output "consul_servers_ids" {
  value = aws_instance.consul[*].id
}

output  "consul_server" {
  value = aws_instance.consul
}

output "lb_consul_dns" {
  value = aws_lb.consul_lb[*].dns_name
}

output "consul_iam_instance_profile_name" {
  value = aws_iam_instance_profile.consul-join.name
}