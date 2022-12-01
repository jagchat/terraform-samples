provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
  token      = "" #for MFA
}

resource "aws_s3_bucket" "b" {
  bucket = "jag-tf-test-bucket"
  #acl = "private" #this is deprecated and thus need to use another resource

  tags = {
    Name        = "Jag Test bucket"
    Environment = "JagTest"
    CreatedBy   = "Jag"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}
