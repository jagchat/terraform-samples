terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
  token      = "" #for MFA
}

locals {
  hosted_zone_name = "dev.notifications.rnd.zone"
  domain_name      = "dev.notifications.rnd.zone"
}

data "aws_route53_zone" "dns_zone" {
  private_zone = false
  name         = local.hosted_zone_name
}

#Create API Gateway first
module "api-gateway" {
  source      = "./api-gateway"
  domain_name = local.domain_name
}

#Create SSL certificate
module "ssl-certificate" {
  source      = "./ssl-certificate"
  domain_name = local.domain_name
  zone_id     = data.aws_route53_zone.dns_zone.id
  depends_on = [
    module.api-gateway
  ]
}

#Deploy API Gateway
module "api-gateway-deploy" {
  source      = "./api-gateway-deploy"
  domain_name = local.domain_name
  rest_api_id = module.api-gateway.rest_api_id
  depends_on = [
    module.api-gateway,
    module.ssl-certificate
  ]
}
