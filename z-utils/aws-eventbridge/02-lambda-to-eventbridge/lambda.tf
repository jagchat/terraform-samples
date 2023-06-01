
resource "aws_iam_role" "event_forwarder_lambda_role" {
  name = "event_forwarder_lambda_role"

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

resource "aws_iam_policy" "event_forwarder_lambda_policy" {

  name        = "event_forwarder_lambda_policy"
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
   },
   {
      "Effect": "Allow",
      "Action": [
        "events:PutEvents"
      ],
      "Resource": [
        "arn:aws:events:*:*"
      ]
    }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "event_forwarder_lambda_attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.event_forwarder_lambda_role.name
  policy_arn = aws_iam_policy.event_forwarder_lambda_policy.arn
}

data "archive_file" "lambda_app_zip" {
  type       = "zip"
  source_dir = "${path.module}/node-js-sample/app"
  #source_file = "index.js" #if one file
  output_path = "${path.module}/node-js-sample/app.zip"
}

resource "aws_lambda_function" "event_forwarder_lambda" {
  filename         = "${path.module}/node-js-sample/app.zip"
  function_name    = "event_forwarder_lambda"
  role             = aws_iam_role.event_forwarder_lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_app_zip.output_base64sha256
  runtime          = "nodejs14.x"
  depends_on = [
    aws_iam_role_policy_attachment.event_forwarder_lambda_attach_iam_policy_to_iam_role
  ]
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  //NOTE: naming convention is essential and must follow as described below
  name              = "/aws/lambda/${aws_lambda_function.event_forwarder_lambda.function_name}"
  retention_in_days = 1
  lifecycle {
    prevent_destroy = false
  }
}
