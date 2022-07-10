output "jenkins_server_ip"{
  value = aws_instance.jenkins.private_ip
}
output "jenkins_servers_id" {
  value = aws_instance.jenkins.id
}

output  "jenkins_server" {
  value = aws_instance.jenkins
}
#
#output "lb_jenkins_dns" {
#  value = aws_lb.lb[*].dns_name
#}
#output "lb_arn" {
#  value = aws_lb.lb[*].arn
#}
#
#output "lb_zone_id" {
#  value = aws_lb.lb[*].zone_id
#}

output "jenkins_server_sg" {
  value = aws_security_group.jenkins_server.id
}

#output "lb_jenkins_sg_id" {
#  value = aws_security_group.jenkins_lb_sg.id
#}

output "jenkins_instance_profile_name" {
  value = aws_iam_instance_profile.jenkins-master-profile.name
}

output "jenkins_iam_role_arn" {
  value = aws_iam_role.jenkins.arn
}

#output "kandula_tls_arn" {
#  value = aws_acm_certificate.kandula_tls.arn
#}