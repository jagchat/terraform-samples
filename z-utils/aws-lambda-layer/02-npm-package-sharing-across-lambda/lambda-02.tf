
resource "aws_iam_role" "lambda_02_role" {
  name = "lambda_02_role"

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

resource "aws_iam_policy" "lambda_02_policy" {

  name        = "lambda_02_policy"
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

resource "aws_iam_role_policy_attachment" "lambda_02_attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_02_role.name
  policy_arn = aws_iam_policy.lambda_02_policy.arn
}

data "archive_file" "lambda_02_zip" {
  type       = "zip"
  source_dir = "${path.module}/lambda-02"
  #source_file = "index.js" #if one file
  output_path = "${path.module}/lambda-02.zip"
}

resource "aws_lambda_function" "lambda_02" {
  filename         = "${path.module}/lambda-02.zip"
  function_name    = "lambda-02"
  role             = aws_iam_role.lambda_02_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_02_zip.output_base64sha256
  runtime          = "nodejs14.x"
  depends_on = [
    aws_iam_role_policy_attachment.lambda_02_attach_iam_policy_to_iam_role
  ]
  layers = [module.sample_layer.lambda_layer_arn]
}

