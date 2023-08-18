
data "aws_iam_policy_document" "tenant-eventbridge-assume-role-policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }

}

# iam permission to allow API invocation for API destinations
resource "aws_iam_policy" "tenant_eventbridge_policy" {

  name        = "${local.namespace}-tenant_eventbridge_policy"
  path        = "/"
  description = "Allows put events to central event bus"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "events:*"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:events:us-east-2:264955239305:event-bus/sample-dev-central-event-bus"
        ]
      },
    ]
  })
}

# create the IAM role
resource "aws_iam_role" "tenant-eventbridge-role" {
  name               = "${local.namespace}-tenant-eventbridge-assume-role"
  assume_role_policy = data.aws_iam_policy_document.tenant-eventbridge-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "tenant-eventbridge-role_attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.tenant-eventbridge-role.id
  policy_arn = aws_iam_policy.tenant_eventbridge_policy.arn
}

resource "aws_cloudwatch_event_bus" "tenant_event_bus" {
  name = "${local.namespace}-tenant-event-bus"
}

resource "aws_cloudwatch_event_rule" "all-events-rule" {
  name           = "${local.namespace}-tenant-event-bus-all_tenant_events"
  description    = "All Events"
  event_bus_name = "${local.namespace}-tenant-event-bus"
  event_pattern = jsonencode({
    "source" : [{ "prefix" : "central.event.fromtenant" }]
  })
  depends_on = [aws_cloudwatch_event_bus.tenant_event_bus]
}

resource "aws_cloudwatch_event_target" "tenant-event-bus-logs" {
  target_id      = "${local.namespace}-tenant-events-cloudwatch-target"
  rule           = aws_cloudwatch_event_rule.all-events-rule.name
  arn            = aws_cloudwatch_log_group.tenant-events-log-group.arn
  event_bus_name = "${local.namespace}-tenant-event-bus"
  dead_letter_config {
    arn = aws_sqs_queue.tenant_events_dead_letter_queue.arn
  }
}

resource "aws_cloudwatch_event_target" "central-event-bus-destination" {
  target_id      = "${local.namespace}-central-event-bus-target"
  rule           = aws_cloudwatch_event_rule.all-events-rule.name
  arn            = "arn:aws:events:us-east-2:264955239305:event-bus/sample-dev-central-event-bus"
  role_arn       = aws_iam_role.tenant-eventbridge-role.arn
  event_bus_name = "${local.namespace}-tenant-event-bus"
  dead_letter_config {
    arn = aws_sqs_queue.tenant_events_dead_letter_queue.arn
  }
}

resource "aws_cloudwatch_log_group" "tenant-events-log-group" {
  //NOTE: naming convention is essential and must follow as described below
  name_prefix       = "/aws/events/${local.namespace}-tenant-event-bus-"
  retention_in_days = 1
}

resource "aws_sqs_queue" "tenant_events_dead_letter_queue" {
  name = "${local.namespace}-tenant_events_dlq"
}

resource "aws_sqs_queue_policy" "tenant_events_dlq_policy" {
  queue_url = aws_sqs_queue.tenant_events_dead_letter_queue.id
  policy    = data.aws_iam_policy_document.tenant_events_dlq_policy_doc.json
}

data "aws_iam_policy_document" "tenant_events_dlq_policy_doc" {
  statement {
    actions = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [
      aws_sqs_queue.tenant_events_dead_letter_queue.arn
    ]
    effect = "Allow"
  }
}

