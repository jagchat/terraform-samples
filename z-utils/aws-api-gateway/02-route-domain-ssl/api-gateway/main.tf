variable "domain_name" {}

resource "aws_api_gateway_rest_api" "rest_api" {
  name = "sample-rest-api"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

#->define REST resource
resource "aws_api_gateway_resource" "rest_api_resource_emp" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id # says to start from root (like /employee)
  path_part   = "employee"
}

#->define HTTP Method for REST resource
resource "aws_api_gateway_method" "rest_api_emp_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.rest_api_resource_emp.id
  http_method   = "GET" # HTTP GET for /employee
  authorization = "NONE"
}

#->associate HTTP Method (of REST resource) to background service (like Lambda etc)
#--->In this case, we are opting for MOCK service (as we don't have Lambda)
resource "aws_api_gateway_integration" "rest_api_emp_get_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource_emp.id
  http_method = aws_api_gateway_method.rest_api_emp_get_method.http_method
  type        = "MOCK"

  //request_tempates is required to explicitly set the statusCode to an integer value of 200
  //this is just for the MOCK
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }

}

#->define what GET should return as "status" when "GET /employee" invoked (as we opted for MOCK)
resource "aws_api_gateway_method_response" "rest_api_emp_get_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource_emp.id
  http_method = aws_api_gateway_method.rest_api_emp_get_method.http_method
  status_code = "200" #always returns HTTP Success (for this MOCK)
}

#->define what GET should return as "body" when "GET /employee" invoked (as we opted for MOCK)
resource "aws_api_gateway_integration_response" "rest_api_get_method_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource_emp.id
  http_method = aws_api_gateway_integration.rest_api_emp_get_method_integration.http_method
  status_code = aws_api_gateway_method_response.rest_api_emp_get_method_response_200.status_code
  response_templates = { #always returns same data
    "application/json" = jsonencode({
      "empno" : 1001,
      "ename" : "Jag"
    })
  }
}

#->following resources deploy the api for respective stage
resource "aws_api_gateway_deployment" "rest_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.rest_api_emp_get_method_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  triggers = {
    redeployment = sha1(timestamp())
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_api_gateway_stage" "rest_api_stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "dev"
}
resource "aws_api_gateway_base_path_mapping" "rest_api_base_path_mapping" {
  api_id      = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.rest_api_stage.stage_name
  domain_name = var.domain_name
}
