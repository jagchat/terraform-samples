provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region

  default_tags {
    tags = merge(
      var.additional_tags,
      {
        app : var.app,
        env : var.env
      }
    )
  }
}

locals {
  aws_account_arn = "arn:aws:iam::${var.aws_account_id}:root"
}

resource "aws_resourcegroups_group" "resource_group" {
  name = var.app

  resource_query {
    query = <<-JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "app",
      "Values": ["${var.app}"]
    },
    {
      "Key": "env",
      "Values": ["${var.env}"]
    }
  ]
}
  JSON
  }
}

module "tf-state-backend" {
  source          = "./mod-backend"
  app             = var.app
  env             = var.env
  aws_account_arn = local.aws_account_arn
}
