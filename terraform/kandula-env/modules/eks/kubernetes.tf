## # Kubernetes provider
## # https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster#optional-configure-terraform-kubernetes-provider
## # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/terraform/kubernetes/deploy-nginx-kubernetes
#
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

resource "kubernetes_service_account" "kandula_eks_sa" {
  metadata {
    name      = local.k8s_service_account_name
    namespace = local.k8s_service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_admin.iam_role_arn
    }
  }
  depends_on = [module.eks]
}

resource "kubernetes_secret" "kandula_secret" {
  metadata {
    name = "kandula-secret"
   # namespace = local.k8s_service_account_namespace
  }
  binary_data = {
      "AWS_ACCESS_KEY_ID" = var.access_key
      "AWS_SECRET_ACCESS_KEY" = var.secret_key
      }
  type = "Opaque"
  depends_on = [module.eks]
  }

#provider "helm" {
#  kubernetes {
#    host                   = data.aws_eks_cluster.eks.endpoint
#    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#    token                  = data.aws_eks_cluster_auth.eks.token
#  }
#}