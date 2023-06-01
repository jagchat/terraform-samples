
module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name                 = "jag-event-bus"
  attach_cloudwatch_policy = true
  cloudwatch_target_arns = [
    aws_cloudwatch_log_group.eventbridge-log-group.arn
  ]
  rules = {
    product_create = {
      description = "product create rule",
      event_pattern = jsonencode({
        "source" : ["product.create"]
      })
    }
  }

  targets = {
    product_create = [
      {
        name            = "send-logs-to-cloudwatch"
        arn             = aws_cloudwatch_log_group.eventbridge-log-group.arn
        dead_letter_arn = aws_sqs_queue.dead_letter_queue.arn
      }
    ]
  }

}

data "aws_iam_policy_document" "eventbridge-log-publishing-policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "events:PutEvents"
    ]

    resources = ["arn:aws:logs:*"]

    principals {
      identifiers = [
        "events.amazonaws.com",
        "delivery.logs.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "eventbridge-log-publishing-policy" {
  policy_document = data.aws_iam_policy_document.eventbridge-log-publishing-policy.json
  policy_name     = "eventbridge-log-publishing-policy"
}

resource "aws_cloudwatch_log_group" "eventbridge-log-group" {
  //NOTE: naming convention is essential and must follow as described below
  name_prefix       = "/aws/events/jag-event-bus"
  retention_in_days = 1
}

resource "aws_sqs_queue" "dead_letter_queue" {
  name = "jag-event-bus-dlq"
}

resource "aws_sqs_queue_policy" "dlq_policy" {
  queue_url = aws_sqs_queue.dead_letter_queue.id
  policy    = data.aws_iam_policy_document.dlq_policy_doc.json
}

data "aws_iam_policy_document" "dlq_policy_doc" {
  statement {
    actions = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [
      aws_sqs_queue.dead_letter_queue.arn
    ]
    effect = "Allow"
  }
}
