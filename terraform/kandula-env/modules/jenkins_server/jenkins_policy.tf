# Create an IAM role for the auto-join
resource "aws_iam_role" "jenkins" {
  name               = "${var.tag_name}-jenkins"
  assume_role_policy = file("${path.module}/../../iam_policies/assume_role.json")
}

# Create the policy
resource "aws_iam_policy" "jenkins-master-policy" {
  name        = "${var.tag_name}-jenkins-master-policy"
  description = "Allows Consul nodes to describe instances for joining."
  policy      = file("${path.module}/../../iam_policies/get_secrets.json")
}

resource "aws_iam_policy" "jenkins-master-consul-policy" {
  name        = "${var.tag_name}-jenkins-consul-join-policy"
  description = "Allows Consul nodes to describe instances for joining."
  policy      = file("${path.module}/../../iam_policies/describe_instances.json")
}

resource "aws_iam_policy" "kandula-eks-policy" {
  name        = "${var.tag_name}-eks-policy"
  description = "Allows node  to use kubectl with eks cluster."
  policy      = file("${path.module}/../../iam_policies/eks_admin.json")
}


# Attach the policy
resource "aws_iam_role_policy_attachment" "jenkins-master-consul-attach" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins-master-consul-policy.arn
}

resource "aws_iam_role_policy_attachment" "jenkins-master-policy-attach" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins-master-policy.arn
}

resource "aws_iam_role_policy_attachment" "flask-attach" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}


resource "aws_iam_role_policy_attachment" "eks-attach" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.kandula-eks-policy.arn
}


# Create the instance profile
resource "aws_iam_instance_profile" "jenkins-master-profile" {
  name  ="${var.tag_name}-jenkins-master-profile"
  role = aws_iam_role.jenkins.name
}


## Create the policy
#resource "aws_iam_policy" "jenkins" {
#  name        = "${var.tag_name}-jenkins"
#  description = "Allows get secrets."
#  policy      = templatefile("${path.module}/iam_policies/jenkis_permissions.tftpl" , {bucket = var.jenkins_bucket_name}
#                 )
#}

## Attach the policy
#resource "aws_iam_policy_attachment" "jenkins" {
#  name       = "${var.tag_name}-jenkins"
#  roles      = [aws_iam_role.jenkins.name]
#  policy_arn = aws_iam_policy.jenkins.arn
#}

#
## Create the instance profile
#resource "aws_iam_instance_profile" "jenkins" {
#  name = "${var.tag_name}-jenkins"
#  role = aws_iam_role.jenkins.name
#}