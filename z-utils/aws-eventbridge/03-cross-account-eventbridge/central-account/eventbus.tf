module "eventbridge-central-events" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name                 = "${local.namespace}-central-event-bus"
  attach_cloudwatch_policy = true
  create_permissions       = true
  permissions = {
    "* ${local.namespace}-AccessToExternalBus" = {
      event_bus_name = "${local.namespace}-central-event-bus"
      //condition_org  = "o-s7as03247s"
    }
  }

  cloudwatch_target_arns = [
    aws_cloudwatch_log_group.central-events-log-group.arn
  ]
  rules = {
    all_central_events = {
      description = "All Events",
      event_pattern = jsonencode({
        "source" : [{ "prefix" : "central.event" }]
      })
    }
  }

  targets = {
    all_central_events = [
      {
        name            = "${local.namespace}-central-events-cloudwatch-target"
        arn             = aws_cloudwatch_log_group.central-events-log-group.arn
        dead_letter_arn = aws_sqs_queue.central_events_dead_letter_queue.arn
      }
    ]
  }

}

/* resource "aws_cloudwatch_event_permission" "OrganizationAccess" {
  principal      = "*"
  statement_id   = "${local.namespace}-central-event-bus-OrganizationAccess"
  event_bus_name = "${local.namespace}-central-event-bus"
  condition {
    key   = "aws:PrincipalOrgID"
    type  = "StringEquals"
    value = "o-s7as03247s" //org id
  }
  depends_on = [eventbridge-central-events]
} */

resource "aws_cloudwatch_log_group" "central-events-log-group" {
  //NOTE: naming convention is essential and must follow as described below
  name_prefix       = "/aws/events/${local.namespace}-central-event-bus-"
  retention_in_days = 1
}

resource "aws_sqs_queue" "central_events_dead_letter_queue" {
  name = "${local.namespace}-central_events_dlq"
}

resource "aws_sqs_queue_policy" "central_events_dlq_policy" {
  queue_url = aws_sqs_queue.central_events_dead_letter_queue.id
  policy    = data.aws_iam_policy_document.central_events_dlq_policy_doc.json
}

data "aws_iam_policy_document" "central_events_dlq_policy_doc" {
  statement {
    actions = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [
      aws_sqs_queue.central_events_dead_letter_queue.arn
    ]
    effect = "Allow"
  }
}

