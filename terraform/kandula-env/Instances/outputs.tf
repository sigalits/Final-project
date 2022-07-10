#output "ec2_private_ip_kandula_instance" {
#  value = module.web-server.kandula_private_ips[*]
#}
#
#output "ec2_public_ip_kandula_instance" {
#  value = module.web-server.kandula_public_ips[*]
#}
#
#output "ec2_private_ip_database_instance" {
#  value = module.database.database_servers_ips[*]
#}

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

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

# output "kubectl_config" {
#   description = "kubectl config as generated by the module."
#   value       = module.eks.kubeconfig
# }

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "Jenkins_nodes_ip" {
  value = aws_instance.jenkins-node[*].private_ip
}


output "bastion_ip" {
  value = module.bastion.bastion_servers_public_ips[0]
}

output "Jenkins_alb" {
  value = aws_lb.jenkins_lb[*].dns_name
}

output "consul_alb" {
  value = module.consul.lb_consul_dns
}

#output "eks_instance_desired_size_eks" {
#  value = module.eks.eks_instance_desired_size_eks
#}

output "db_setup_script" {
  value = var.db_setup_script_filepath
}

output "rds_endpoint" {
  value = aws_db_instance.kandula-db.address
}

output "rds_port" {
  value = aws_db_instance.kandula-db.port
}

output "elk_server_public_ip" {
  value = module.ec2-instance.public_ip[*]
}
#output "kibana_url" {
#  value= "https://${aws_route53_record.jenkins_record[0].name}.${data.terraform_remote_state.vpc.outputs.domain_name}:5601"
# # value = "http://${module.ec2-instance.public_ip[0]}:5601"
#}

output "Jenkins_master_ip" {
  value = module.jenkins_server.jenkins_server_ip
}

output "acm_certificate_arn" {
  description = "ARN of the ACM Certificate"
  value       = aws_acm_certificate.cert.arn
}
