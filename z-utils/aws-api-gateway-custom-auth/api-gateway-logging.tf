resource "aws_api_gateway_account" "gateway_acc" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "default"
  role = aws_iam_role.cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

//this is only needed once to kick-off settings for API Gateway.
//no need to modify this resource for new/other methods
resource "aws_api_gateway_method_settings" "general_settings" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id
  stage_name  = local.stage_name
  method_path = "*/*"

  settings {
    # Enable CloudWatch logging and metrics
    metrics_enabled = true
    //data_trace_enabled = true
    logging_level = "INFO"

    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }

  depends_on = [ //a must
    aws_api_gateway_deployment.apiGatewayDeployment,
    aws_api_gateway_stage.apiGatewayStage,
    module.GetStatusLambda,
    aws_api_gateway_account.gateway_acc
  ]
}

resource "aws_cloudwatch_log_group" "gateway-log-group" {
  //NOTE: naming convention is essential and must follow as described below
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.apiGateway.id}/${local.stage_name}"
  retention_in_days = 1
}
