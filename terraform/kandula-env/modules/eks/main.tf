data "aws_caller_identity" "current" {}

locals  {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "${var.tag_name}-eks-worker-management-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [ var.vpc_cidr ]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Consul"
    from_port = 8300
    protocol  = "tcp"
    to_port   = 8303
    cidr_blocks = [var.vpc_cidr]
  }

    ingress {
    description = "Consul"
    from_port = 9153
    to_port   = 9153
    protocol  = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    description = "Consul"
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    description = "Consul"
    from_port   = 8500
    to_port     = 8505
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    description = "grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    description = "Consul"
    from_port   = 9000
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
 }

locals {
  desired_size   = var.create_eks ? var.eks_instance_count: 0
}
output "eks_create_eks_from_eks" {
  value = var.create_eks
}

output "eks_instance_count_from_eks" {
  value = var.eks_instance_count
}

output "eks_instance_desired_size_eks" {
  value = local.desired_size
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  #version         = "18.6.1"
  version         = "18.20"
  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = var.private_subnet_ids

  enable_irsa = true
  manage_aws_auth_configmap = true
  create_cloudwatch_log_group            =  false
  cloudwatch_log_group_retention_in_days =  1
  aws_auth_roles = [
    {
      rolearn  = var.jenkins_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:masters"]
    }
  ]
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 0
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
    ingress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 0
      to_port                    = 65535
      type                       = "ingress"
      source_node_security_group = true
    }
  }
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    rds_port = {
          type                     = "egress"
          from_port                = var.db_port
          to_port                  = var.db_port
          protocol                 = "tcp"
          source_security_group_id = var.rds_sg_id
          description              = "Allow psql port tcp"
        }
     consul_port_8080 = {
          type                     = "ingress"
          from_port                = 8080
          to_port                  = 8080
          protocol                 = "tcp"
          source_security_group_id = var.common_security_group_id
          description              = "Allow consul port 8080"
        }
      elastic_port_9200 = {
          type                     = "egress"
          from_port                = 9200
          to_port                  = 9200
          protocol                 = "tcp"
          source_security_group_id = var.common_security_group_id
          description              = "Allow elastic port 9200 out"
        }
    }

  tags = {
    Environment = "Kandula"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = var.vpc_id

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    #instance_types         = ["t3.medium"]
    instance_types         = var.eks_instance_types_1
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id , var.common_security_group_id]
    iam_role_additional_policies = ["arn:aws:iam::${local.account_id}:policy/route53"]
  }

  eks_managed_node_groups = {

    group_1 = {
      min_size       = 0 #var.create_eks ? 2: 0
      max_size       = 6
      desired_size   = var.create_eks ? var.eks_instance_count: 0
      #instance_types = ["t3.medium"]
      instance_types = var.eks_instance_types_1
      tags = {
        purpose = "eks" ,
        consul_agent = "true"
      }
    }

    group_2 = {
      min_size       = 0 #var.create_eks ? 2: 0
      max_size       = 6
      desired_size   = var.create_eks ? var.eks_instance_count: 0
      instance_types = var.eks_instance_types_2
      #instance_types = ["t3.large"]
       tags = {
        purpose = "eks" ,
        consul_agent = "true"
      }
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

