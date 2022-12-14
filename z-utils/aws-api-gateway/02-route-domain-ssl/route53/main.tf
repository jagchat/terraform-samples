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
  hosted_zone_name = "rnd.zone"
}

resource "aws_route53_zone" "dns_zone" {
  name = local.hosted_zone_name
}


