# Create an IAM role for the auto-join
resource "aws_iam_role" "jenkins" {
  name               = "${var.tag_name}-jenkins"
  assume_role_policy = file("${path.module}/iam_policies/assume_role.json")
}

# Create the policy
resource "aws_iam_policy" "jenkins" {
  name        = "${var.tag_name}-jenkins"
  description = "Allows get secrets."
  policy      = templatefile("${path.module}/iam_policies/jenkis_permissions.tftpl" , {bucket = var.jenkins_bucket_name}
                 )
}

# Attach the policy
resource "aws_iam_policy_attachment" "jenkins" {
  name       = "${var.tag_name}-jenkins"
  roles      = [aws_iam_role.jenkins.name]
  policy_arn = aws_iam_policy.jenkins.arn
}


# Create the instance profile
resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.tag_name}-jenkins"
  role = aws_iam_role.jenkins.name
}