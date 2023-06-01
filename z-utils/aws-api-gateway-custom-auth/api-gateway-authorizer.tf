module "ValidateTokenLambda" {
  source                = "./lambdas/validate-token-lambda"
  lambda_logs_retention = local.lambda_logs_retention
}

resource "aws_iam_role" "invocation_role" {
  name               = "api_gateway_auth_invocation"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invocation_policy" {
  name   = "api_gatway_auth_policy"
  role   = aws_iam_role.invocation_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Effect": "Allow",
      "Sid": "Invoke",
      "Resource": "arn:aws:lambda:*:*:*:*"
    }
  ]
}
EOF
}

resource "aws_api_gateway_authorizer" "getSumAuthorizer" {
  name                   = "getSum"
  type                   = "TOKEN"
  rest_api_id            = aws_api_gateway_rest_api.apiGateway.id
  authorizer_uri         = module.ValidateTokenLambda.invoke_arn
  authorizer_credentials = aws_iam_role.invocation_role.arn
}

