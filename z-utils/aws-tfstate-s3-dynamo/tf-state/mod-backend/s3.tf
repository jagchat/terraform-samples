locals {
  namespace = "${var.app}-${var.env}"
}

resource "aws_s3_bucket" "tfstate" {
  bucket        = "${local.namespace}-tfstate"
  force_destroy = "true"
}

resource "aws_s3_bucket_acl" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "tfstate_policy" {
  bucket = aws_s3_bucket.tfstate.id
  policy = data.aws_iam_policy_document.tfstate_policy.json
}

data "aws_iam_policy_document" "tfstate_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.aws_account_arn]
    }

    actions = [
      "*",
    ]

    resources = [
      aws_s3_bucket.tfstate.arn
    ]
  }
}
