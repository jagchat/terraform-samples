#set role/permissions on what ec2 instance can do

#Create a policy
resource "aws_iam_policy" "ec2_linux_policy" {
  name        = "${local.namespace}-ec2_linux_policy"
  path        = "/"
  description = "Policy to provide permission to EC2"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "events:*"
        ],
        Resource = ["arn:aws:events:*"]
      }
    ]
  })
}

#Create a role
resource "aws_iam_role" "ec2_linux_role" {
  name = "${local.namespace}-ec2_linux_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#Attach role to policy
resource "aws_iam_role_policy_attachment" "custom" {
  role       = aws_iam_role.ec2_linux_role.name
  policy_arn = aws_iam_policy.ec2_linux_policy.arn
}

#Attach role to an instance profile
resource "aws_iam_instance_profile" "ec2_linux_profile" {
  name = "${local.namespace}-ec2_linux_profile"
  role = aws_iam_role.ec2_linux_role.name
}
