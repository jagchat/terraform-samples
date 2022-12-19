resource "aws_dynamodb_table" "tfstate" {
  name         = "${local.namespace}-tfstate"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}
