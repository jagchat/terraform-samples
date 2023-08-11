terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
  /* access_key = "AKIAWJZCVCUUDGEFVPW6"
  secret_key = "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"
  token      = "" #for MFA */
}
