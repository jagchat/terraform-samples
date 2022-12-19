variable "aws_region" {}
variable "aws_profile" {}
variable "aws_account_id" {}
variable "app" {}
variable "env" {}
variable "additional_tags" {
  type = map(any)
}

