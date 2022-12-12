terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
  token      = "" #for MFA
}

resource "aws_iam_role" "roll_a_dice_lambda_role" {
  name = "roll_a_dice_lambda_role"

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

resource "aws_iam_policy" "roll_a_dice_lambda_policy" {

  name        = "roll_a_dice_lambda_policy"
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

resource "aws_iam_role_policy_attachment" "roll_a_dice_lambda_attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.roll_a_dice_lambda_role.name
  policy_arn = aws_iam_policy.roll_a_dice_lambda_policy.arn
}

data "archive_file" "lambda_app_zip" {
  type       = "zip"
  source_dir = "${path.module}/node-js-sample/app"
  #source_file = "index.js" #if one file
  output_path = "${path.module}/node-js-sample/app.zip"
}

resource "aws_lambda_function" "roll_a_dice_lambda" {
  filename         = "${path.module}/node-js-sample/app.zip"
  function_name    = "roll_a_dice_lambda"
  role             = aws_iam_role.roll_a_dice_lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_app_zip.output_base64sha256
  runtime          = "nodejs14.x"
  depends_on = [
    aws_iam_role_policy_attachment.roll_a_dice_lambda_attach_iam_policy_to_iam_role
  ]
}
