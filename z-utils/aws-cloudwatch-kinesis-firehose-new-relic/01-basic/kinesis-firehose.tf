resource "aws_s3_bucket" "logs_bucket" {
  bucket = "cloudwatch-failed-logs-from-firehose-to-new-relic"
}

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "firehose_role" {
  name               = "firehose_test_role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

resource "aws_iam_role_policy" "firehose_role_policy" {
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["s3:*"],
        "Resource" : "*",
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:*:*:log-group:*:log-stream:*"
        ]
      }
    ],
  })
}

resource "aws_kinesis_firehose_delivery_stream" "log_stream" {
  name        = "terraform-kinesis-firehose-test"
  destination = "http_endpoint"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.logs_bucket.arn
    buffer_size        = 10  # MiB
    buffer_interval    = 300 # seconds
    compression_format = "GZIP"
  }

  http_endpoint_configuration {
    url                = "https://aws-api.newrelic.com/firehose/v1"
    name               = "New Relic - Metrics"
    access_key         = "<key>"
    buffering_size     = 1  # MiB
    buffering_interval = 60 # seconds
    role_arn           = aws_iam_role.firehose_role.arn
    s3_backup_mode     = "FailedDataOnly"
    retry_duration     = 60 # seconds

    request_configuration {
      content_encoding = "GZIP"
    }
  }
  depends_on = [aws_iam_role_policy.firehose_role_policy]
}
