output "jenkins_server_ip"{
  value = aws_instance.jenkins.private_ip
}
output "jenkins_servers_ids" {
  value = aws_instance.jenkins[*].id
}

output  "jenkins_server" {
  value = aws_instance.jenkins
}

output "lb_jenkins_dns" {
  value = aws_lb.lb.dns_name
}
output "lb_arn" {
  value = aws_lb.lb.arn
}

output "lb_zone_id" {
  value = aws_lb.lb.zone_id
}