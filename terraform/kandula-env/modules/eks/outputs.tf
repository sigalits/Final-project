output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks[*].cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks[*].cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks[*].cluster_security_group_id
}
#########################
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
  value       = var.cluster_name
}

output "oidc_provider_arn" {
  value = module.eks[*].oidc_provider_arn
}

output "all_worker_mgmt_sg_id" {
  value = aws_security_group.all_worker_mgmt.id
}

output "r53_policy_arn" {
  value = aws_iam_policy.route53.arn
}