resource "aws_dynamodb_table" "event-log" {
  name         = "event-log"
  hash_key     = "uid"
  range_key    = "ulid"
  billing_mode = "PAY_PER_REQUEST"
  ttl {
    enabled        = true
    attribute_name = "ExpirationTime"
  }
  attribute {
    name = "uid"
    type = "S"
  }
  attribute {
    name = "ulid"
    type = "S"
  }
  attribute {
    name = "TimeStamp"
    type = "S"
  }
  attribute {
    name = "MessageType"
    type = "S"
  }
  global_secondary_index {
    name               = "TimeStampIndex"
    hash_key           = "TimeStamp"
    projection_type    = "INCLUDE"
    non_key_attributes = ["uid"]
  }
  global_secondary_index {
    name               = "MessageTypeIndex"
    hash_key           = "MessageType"
    projection_type    = "INCLUDE"
    non_key_attributes = ["uid"]
  }
}
