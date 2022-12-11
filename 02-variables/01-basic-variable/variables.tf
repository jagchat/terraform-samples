#->just basic declaration as follows is valid
#variable "my_bucket_name" {}

#->we can define type of variable and default value as follows
variable "my_bucket_name" {
  type        = string
  default     = "jag-tf-test-bucket"
  description = "bucket name to be used for S3"
}
