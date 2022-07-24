resource "aws_iam_policy" "route53" {
  name        = "route53"
  description = "Allows eks to add dns names to route53."
  policy      = file("${path.module}/../../iam_policies/external_dns.json")
}