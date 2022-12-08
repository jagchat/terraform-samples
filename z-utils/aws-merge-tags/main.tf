provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
  token      = "" #for MFA
}

resource "aws_s3_bucket" "b" {
  bucket = "jag-tf-test-bucket"

  #--if direct and no merge
  #tags = var.my_tags

  #--if needs to be merged
  tags = (merge(
    var.my_tags,
    tomap({
      "CreatedBy" : "Jag"
    })
  ))
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}
