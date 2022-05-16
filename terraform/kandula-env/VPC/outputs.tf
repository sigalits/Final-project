output "Jenkins_master_ip" {
  value = module.jenkins_server.jenkins_server_ip
}

output "Jenkins_alb_dns" {
  value = module.jenkins_server.lb_jenkins_dns
}

output "lb_arn" {
  value = module.jenkins_server.lb_arn
}

output "public_subnets" {
  value = module.vpc.public_subnets
}
output "jenkins_instance_profile_name" {
  value = aws_iam_instance_profile.jenkins.name
}

#output "database_subnets" {
#  value = module.vpc.database_subnets
#}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "main_route_table_id" {
  value = module.vpc.main_route_table_id
}

output "jenkins_server_sg" {
  value = aws_security_group.jenkins_server.id
}

output "lb_jenkins_sg_id" {
  value = aws_security_group.jenkins_lb_sg.id
}

output "common_sg_id" {
  value = module.vpc.common_sg_id
}


output "eks_cluster_name" {
  value = module.vpc.eks_cluster_name
}
