resource "aws_s3_bucket" "logs_bucket" {
  bucket = "cloudwatch-logs-from-firehose-bucket"
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
  destination = "extended_s3"
  extended_s3_configuration {
    role_arn        = aws_iam_role.firehose_role.arn
    bucket_arn      = aws_s3_bucket.logs_bucket.arn
    buffer_interval = 60
  }
  depends_on = [aws_iam_role_policy.firehose_role_policy]
}
