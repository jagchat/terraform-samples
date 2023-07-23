
resource "aws_iam_role" "lambda-layer-demo_role" {
  name = "lambda-layer-demo_role"

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

resource "aws_iam_policy" "lambda-layer-demo_policy" {

  name        = "lambda-layer-demo_policy"
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

resource "aws_iam_role_policy_attachment" "lambda-layer-demo_attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda-layer-demo_role.name
  policy_arn = aws_iam_policy.lambda-layer-demo_policy.arn
}

/*----------------------------------------------------------------*/
/* METHOD 1 */
/*----------------------------------------------------------------*/
data "archive_file" "lambda_app_zip" {
  type       = "zip"
  source_dir = "${path.module}/lambda-handler"
  #source_file = "index.js" #if one file
  output_path = "${path.module}/lambda-handler.zip"
}

resource "aws_lambda_function" "lambda-layer-demo" {
  filename         = "${path.module}/lambda-handler.zip"
  function_name    = "lambda-layer-demo"
  role             = aws_iam_role.lambda-layer-demo_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_app_zip.output_base64sha256
  runtime          = "nodejs14.x"
  depends_on = [
    aws_iam_role_policy_attachment.lambda-layer-demo_attach_iam_policy_to_iam_role
  ]
  layers = [module.sample_layer_lambda_layer.lambda_layer_arn]
}


/*----------------------------------------------------------------*/
/* METHOD 2 */
/*----------------------------------------------------------------*/
/* module "lambda_layer_demo_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.7.0"
  function_name = "lambda-layer-demo"
  description   = "Lambda Layer Demo"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  source_path   = "${path.module}/lambda-handler"
  depends_on = [
    aws_iam_role_policy_attachment.lambda-layer-demo_attach_iam_policy_to_iam_role
  ]
  layers = [module.sample_layer_lambda_layer.lambda_layer_arn]
} */
