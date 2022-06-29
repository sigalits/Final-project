variable "kubernetes_version" {
  default = 1.21
  description = "kubernetes version"
}

variable "aws_region" {
  description = "aws region"
}

locals {
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "kandula-sa"
}
variable "private_subnet_ids" {}
variable "cluster_name" {}
variable "vpc_id" {}
variable "tag_name" {
  type = string
}
variable "common_security_group_id" {}
variable "vpc_cidr" {}
variable "jenkins_role_arn" {}
variable "access_key" {}
variable "secret_key" {}
variable "create_eks" {}
variable "eks_instance_count" {}
variable "eks_instance_types_1" {}
variable "eks_instance_types_2" {}
variable "db_port" {}
variable "rds_sg_id" {}