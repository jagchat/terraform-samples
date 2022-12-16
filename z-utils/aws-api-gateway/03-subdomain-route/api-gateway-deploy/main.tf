variable "domain_name" {}
variable "rest_api_id" {}

#->API Gateway won't be availble unless we deploy the changes to stage.
#->Following resources will deploy the api for respective stage
resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = var.rest_api_id
  triggers = {
    redeployment = sha1(timestamp()) //forcing to redeploy every time
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_api_gateway_stage" "rest_api_stage" {
  //setup stage for deployment
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = var.rest_api_id
  stage_name    = "dev"
}
resource "aws_api_gateway_base_path_mapping" "rest_api_base_path_mapping" {
  //configure domain REST API path mappings
  api_id      = var.rest_api_id
  stage_name  = aws_api_gateway_stage.rest_api_stage.stage_name
  domain_name = var.domain_name
}
