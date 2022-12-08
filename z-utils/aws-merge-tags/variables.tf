variable "my_tags" {
  type = map(any)
  default = {
    "Name"        = "Jag Test bucket"
    "Environment" = "JagTest"
  }
  description = "standard tags"
}
