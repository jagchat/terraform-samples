resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = var.rest_api_id
  //the following says the current path should start from root (like /employee)
  parent_id = var.root_resource_id
  path_part = var.endpoint_path
}

resource "aws_api_gateway_method" "proxyMethod" {
  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "GET"
  authorization = "NONE" //no auth
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_method.proxyMethod.resource_id
  http_method = aws_api_gateway_method.proxyMethod.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_status_lambda.invoke_arn
}

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = aws_lambda_function.get_status_lambda.arn
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.rest_api_execution_arn}/*/*/*"
}

resource "aws_api_gateway_method_response" "response_method" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_method.proxyMethod.resource_id
  http_method = aws_api_gateway_integration.lambda.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "response_method_integration" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_method.proxyMethod.resource_id
  http_method = aws_api_gateway_method_response.response_method.http_method
  status_code = aws_api_gateway_method_response.response_method.status_code
  response_templates = {
    "application/json" = <<EOF
 
 EOF
  }
}

