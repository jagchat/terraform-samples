resource "aws_s3_bucket" "b" {
  bucket = var.my_bucket_name

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
