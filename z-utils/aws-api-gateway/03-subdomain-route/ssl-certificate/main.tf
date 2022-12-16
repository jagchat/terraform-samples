variable "domain_name" {}
variable "zone_id" {}

output "cloudfront_domain_name" {
  value = aws_api_gateway_domain_name.edgeApiGatewayDomain.cloudfront_domain_name
}
output "cloudfront_zone_id" {
  value = aws_api_gateway_domain_name.edgeApiGatewayDomain.cloudfront_zone_id
}
output "certificte_arn" {
  value = aws_acm_certificate.certificate.arn
}


//associate domain to API Gateway along with certificate
resource "aws_api_gateway_domain_name" "edgeApiGatewayDomain" {
  domain_name     = var.domain_name
  certificate_arn = aws_acm_certificate_validation.certificate.certificate_arn
  depends_on = [
    aws_acm_certificate_validation.certificate
  ]
  security_policy = "TLS_1_2"
  endpoint_configuration {
    types = ["EDGE"]
  }
}


//create certificate
resource "aws_acm_certificate" "certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

//create DNS record
resource "aws_route53_record" "dns_record" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.edgeApiGatewayDomain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.edgeApiGatewayDomain.cloudfront_zone_id
  }
}

//create route53 records by extracting information from certificate
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
  zone_id         = var.zone_id
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
}

//validate cerficate to ensure respective domain is valid (DNS needs to be configured to work)
resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate : record.fqdn]
}
