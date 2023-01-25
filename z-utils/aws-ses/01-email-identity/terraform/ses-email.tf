resource "aws_ses_email_identity" "main_email" {
  email = "jag.randd@gmail.com"
}

data "aws_iam_policy_document" "main_email_policy_document" {
  statement {
    actions   = ["SES:SendEmail", "SES:SendRawEmail"]
    resources = [aws_ses_email_identity.main_email.arn]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
}

resource "aws_ses_identity_policy" "main_email_policy" {
  identity = aws_ses_email_identity.main_email.arn
  name     = "main_email_policy"
  policy   = data.aws_iam_policy_document.main_email_policy_document.json
}

