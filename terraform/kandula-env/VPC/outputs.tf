

#output "Jenkins_alb_dns" {
#  value = module.jenkins_server.lb_jenkins_dns
#}
#
#output "lb_arn" {
#  value = module.jenkins_server.lb_arn
#}

output "public_subnets" {
  value = module.vpc.public_subnets
}
#output "jenkins_instance_profile_name" {
#  value = module.jenkins_server.jenkins_instance_profile_name
#}

#output "jenkins_instance_id" {
#  value = module.jenkins_server.lb_zone_id[0]
#}
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

#output "jenkins_server_sg" {
#  value = module.jenkins_server.jenkins_server_sg
#}


#output "lb_jenkins_sg_id" {
#  value = module.jenkins_server.lb_jenkins_sg_id
#}
#
#output "jenkins_alb" {
#  value = module.jenkins_server.lb_jenkins_dns
#}

output "common_sg_id" {
  value = module.vpc.common_sg_id
}


output "eks_cluster_name" {
  value = module.vpc.eks_cluster_name
}

#output "jenkins_iam_role_arn" {
#  value = module.jenkins_server.jenkins_iam_role_arn
#}
#output "kandula_tls_arn" {
#  value = module.jenkins_server.kandula_tls_arn
#}

#output "acm_certificate_arn" {
#  description = "ARN of the ACM Certificate"
#  value       = aws_acm_certificate.cert.arn
#}
#
#output "domain_validation_options" {
#  description = "If your domain isn't managed by Route 53, manually finish the ACM creation by creating these DNS records in your registar service"
#  value       = aws_acm_certificate.cert.domain_validation_options
#}

output "domain_name" {
  value = var.domain_name
}

