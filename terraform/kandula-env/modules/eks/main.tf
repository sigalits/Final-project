resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "${var.tag_name}-eks-worker-management-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [ var.vpc_cidr ]
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.6.1"
  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = var.private_subnet_ids

  enable_irsa = true

  tags = {
    Environment = "Kandula"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = var.vpc_id

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    #instance_types         = ["t3.medium"]
    instance_types         = ["t3.micro"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {

    group_1 = {
      min_size       = 2
      max_size       = 6
      desired_size   = 2
      #instance_types = ["t3.medium"]
      instance_types = ["t3.micro"]
    }

    group_2 = {
      min_size       = 2
      max_size       = 6
      desired_size   = 2
      instance_types = ["t3.medium"]
      #instance_types = ["t3.large"]

    }
  }
}

#resource "null_resource" "module_guardian" {
#
#  triggers = {
#    eqs_id = module.eks.cluster_id
#  }
#
#  lifecycle {
#    prevent_destroy = true
#  }
#}
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}
module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.7.0"
  create_role                   = true
  role_name                     = format("%s-k8s-sa-role", var.tag_name)
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name}"]
}