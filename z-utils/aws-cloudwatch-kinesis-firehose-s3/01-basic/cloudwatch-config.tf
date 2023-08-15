resource "aws_iam_role" "cloudwatch_ingestion_role" {
  name = "cloudwatch_ingestion_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "logs.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "",
      },
    ],
  })
}

resource "aws_iam_role_policy" "cloudwatch_ingestion_policy" {
  role = aws_iam_role.cloudwatch_ingestion_role.name

  policy = jsonencode({
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["firehose:*"],
        "Resource" : [aws_kinesis_firehose_delivery_stream.log_stream.arn],
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : [aws_iam_role.cloudwatch_ingestion_role.arn]
      }
    ],
  })
}

resource "aws_cloudwatch_log_subscription_filter" "sample_lambda_function_logfilter" {
  name            = "sample_lambda_function_logfilter"
  role_arn        = aws_iam_role.cloudwatch_ingestion_role.arn
  log_group_name  = aws_cloudwatch_log_group.sample_lambda_function_log_group.name
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.log_stream.arn
  distribution    = "ByLogStream"

  # Wait until the role has required access before creating
  depends_on = [aws_iam_role_policy.cloudwatch_ingestion_policy]
}
