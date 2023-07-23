
resource "aws_iam_role" "lambda_01_role" {
  name = "lambda_01_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_01_policy" {

  name        = "lambda_01_policy"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_01_attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_01_role.name
  policy_arn = aws_iam_policy.lambda_01_policy.arn
}

data "archive_file" "lambda_01_zip" {
  type       = "zip"
  source_dir = "${path.module}/lambda-01"
  #source_file = "index.js" #if one file
  output_path = "${path.module}/lambda-01.zip"
}

resource "aws_lambda_function" "lambda_01" {
  filename         = "${path.module}/lambda-01.zip"
  function_name    = "lambda-01"
  role             = aws_iam_role.lambda_01_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_01_zip.output_base64sha256
  runtime          = "nodejs14.x"
  depends_on = [
    aws_iam_role_policy_attachment.lambda_01_attach_iam_policy_to_iam_role
  ]
  layers = [
    module.layer_base.lambda_layer_arn
  ]
}

