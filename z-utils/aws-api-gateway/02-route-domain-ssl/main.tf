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
  hosted_zone_name = "rnd.zone"
  domain_name      = "rnd.zone"
}

module "api-gateway" {
  source      = "./api-gateway"
  domain_name = local.domain_name
}

resource "aws_api_gateway_domain_name" "edgeApiGatewayDomain" {
  domain_name     = local.domain_name
  certificate_arn = aws_acm_certificate_validation.certificate.certificate_arn
  depends_on      = [aws_acm_certificate_validation.certificate]
  security_policy = "TLS_1_2"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

data "aws_route53_zone" "dns_zone" {
  private_zone = false
  name         = local.hosted_zone_name
}

resource "aws_route53_record" "dns_record" {
  zone_id = data.aws_route53_zone.dns_zone.id
  name    = local.domain_name
  type    = "A"
  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.edgeApiGatewayDomain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.edgeApiGatewayDomain.cloudfront_zone_id
  }
}

resource "aws_acm_certificate" "certificate" {
  domain_name       = local.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certificate" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name            = each.value.name
  type            = each.value.type
  zone_id         = data.aws_route53_zone.dns_zone.id
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate : record.fqdn]
}


