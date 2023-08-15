
resource "aws_iam_role" "sample_lambda_role" {
  name = "sample_lambda_role"

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

resource "aws_iam_policy" "sample_lambda_policy" {

  name        = "sample_lambda_policy"
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

resource "aws_iam_role_policy_attachment" "sample_lambda_attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.sample_lambda_role.name
  policy_arn = aws_iam_policy.sample_lambda_policy.arn
}

data "archive_file" "lambda_app_zip" {
  type       = "zip"
  source_dir = "${path.module}/sample-lambda"
  #source_file = "index.js" #if one file
  output_path = "${path.module}/sample-lambda.zip"
}

resource "aws_lambda_function" "sample_lambda" {
  filename         = "${path.module}/sample-lambda.zip"
  function_name    = "sample-lambda"
  role             = aws_iam_role.sample_lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_app_zip.output_base64sha256
  runtime          = "nodejs14.x"
  depends_on = [
    aws_iam_role_policy_attachment.sample_lambda_attach_iam_policy_to_iam_role
  ]
}

resource "aws_cloudwatch_log_group" "sample_lambda_function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.sample_lambda.function_name}"
  retention_in_days = 1
  lifecycle {
    prevent_destroy = false
  }
}
