provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
  token      = "" #for MFA
}

#->importing the module
module "my_bucket" {
  source = "./s3-stuff"
  #->can provide module variable values by specifying as follows:
  my_bucket_name = "just-my-bucket"
}
