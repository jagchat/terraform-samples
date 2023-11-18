resource "aws_iam_policy" "ec2_server_policy" {
  name        = "${local.ec2name}-policy"
  path        = "/"
  description = "Policy to provide permission to EC2"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action : [
          "logs:*"
        ],
        Resource : "arn:aws:logs:*:*:*",
        Effect : "Allow"
      }
    ]
  })
}

#Create a role
resource "aws_iam_role" "ec2_server_role" {
  name = "${local.ec2name}-role"

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
  role       = aws_iam_role.ec2_server_role.name
  policy_arn = aws_iam_policy.ec2_server_policy.arn
}

#Attach role to an instance profile
resource "aws_iam_instance_profile" "ec2_server_profile" {
  name = "${local.ec2name}-profile"
  role = aws_iam_role.ec2_server_role.name
}
