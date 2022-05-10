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