resource "aws_sqs_queue" "events_sqs" {
  name = "${local.namespace}-events-queue"
}

//allow sending messages from any account
resource "aws_sqs_queue_policy" "events_sqs_policy" {
  queue_url = aws_sqs_queue.events_sqs.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:*",
      "Resource": "${aws_sqs_queue.events_sqs.arn}"
    }
  ]
}
POLICY
}
