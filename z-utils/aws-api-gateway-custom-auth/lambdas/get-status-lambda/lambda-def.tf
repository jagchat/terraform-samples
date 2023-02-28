resource "aws_iam_role" "get_status_lambda_role" {
  name = "get_status_lambda_role"

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

resource "aws_iam_policy" "get_status_lambda_policy" {

  name        = "get_status_lambda_policy"
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

resource "aws_iam_role_policy_attachment" "get_status_lambda_attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.get_status_lambda_role.name
  policy_arn = aws_iam_policy.get_status_lambda_policy.arn
}

data "archive_file" "lambda_app_zip" {
  type       = "zip"
  source_dir = "${path.module}/app"
  #source_file = "index.js" #if one file
  output_path = "${path.module}/app.zip"
}

resource "aws_lambda_function" "get_status_lambda" {
  filename         = "${path.module}/app.zip"
  function_name    = "get_status_lambda"
  role             = aws_iam_role.get_status_lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_app_zip.output_base64sha256
  runtime          = "nodejs14.x"
  depends_on = [
    aws_iam_role_policy_attachment.get_status_lambda_attach_iam_policy_to_iam_role
  ]
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  //NOTE: naming convention is essential and must follow as described below
  name              = "/aws/lambda/${aws_lambda_function.get_status_lambda.function_name}"
  retention_in_days = var.lambda_logs_retention
  lifecycle {
    prevent_destroy = false
  }
}
