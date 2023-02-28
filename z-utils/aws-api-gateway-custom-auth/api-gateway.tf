resource "aws_api_gateway_rest_api" "apiGateway" {
  name = "demo-custom-auth-api"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

/* resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id
  //the following says the current path should start from root (like /employee)
  parent_id = aws_api_gateway_rest_api.apiGateway.root_resource_id
  path_part = "status"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id
  //the following says the current path should start from root (like /employee)
  parent_id = aws_api_gateway_rest_api.apiGateway.root_resource_id
  path_part = "sum"
} */

module "GetStatusLambda" {
  source                 = "./lambdas/get-status-lambda"
  rest_api_id            = aws_api_gateway_rest_api.apiGateway.id
  root_resource_id       = aws_api_gateway_rest_api.apiGateway.root_resource_id
  rest_api_execution_arn = aws_api_gateway_rest_api.apiGateway.execution_arn
  endpoint_path          = "status"
  stage_name             = local.stage_name
  lambda_logs_retention  = local.lambda_logs_retention
}

module "GetSumLambda" {
  source                 = "./lambdas/get-sum-lambda"
  rest_api_id            = aws_api_gateway_rest_api.apiGateway.id
  root_resource_id       = aws_api_gateway_rest_api.apiGateway.root_resource_id
  rest_api_execution_arn = aws_api_gateway_rest_api.apiGateway.execution_arn
  endpoint_path          = "sum"
  stage_name             = local.stage_name
  lambda_logs_retention  = local.lambda_logs_retention
  authorizer_id          = aws_api_gateway_authorizer.getSumAuthorizer.id
}

resource "aws_api_gateway_deployment" "apiGatewayDeployment" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id

  depends_on = [
    aws_api_gateway_rest_api.apiGateway,
    module.GetStatusLambda,
    module.GetSumLambda
  ]

  triggers = {
    redeployment = sha1(timestamp())
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_api_gateway_stage" "apiGatewayStage" {
  deployment_id        = aws_api_gateway_deployment.apiGatewayDeployment.id
  rest_api_id          = aws_api_gateway_rest_api.apiGateway.id
  stage_name           = local.stage_name
  xray_tracing_enabled = true
  depends_on = [
    aws_cloudwatch_log_group.gateway-log-group
  ]
}
