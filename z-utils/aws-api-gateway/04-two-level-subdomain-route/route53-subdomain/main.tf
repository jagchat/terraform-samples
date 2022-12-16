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
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
  token      = "" #for MFA
}

locals {
  apex_hosted_zone_name     = "rnd.zone"
  notifications_hosted_name = "dev.notifications.rnd.zone"
  route_53_record_name      = "dev.notifications"
}

data "aws_route53_zone" "dns_apex" {
  private_zone = false
  name         = local.apex_hosted_zone_name
}

resource "aws_route53_zone" "dns_notifications" {
  name = local.notifications_hosted_name
}

#Each "parent" hosted zone will need to add a "NS" record for each "child" hosted zone.
#"rnd.zone" would need to have an NS record for "dev.notifications.rnd.zone"
resource "aws_route53_record" "ns_record_notifications" {
  type    = "NS"
  zone_id = data.aws_route53_zone.dns_apex.id
  name    = local.route_53_record_name
  ttl     = 3600
  records = aws_route53_zone.dns_notifications.name_servers
}


