//We can only send email to verfied email address when working in SES sandbox
//When the account is out of the sandbox, we can send email to any verified/non-verified recepient
//Following is only necessary for sandbox to test receiving of email
resource "aws_ses_email_identity" "recepient_email" {
  email = "anthachetta@gmail.com"
}
