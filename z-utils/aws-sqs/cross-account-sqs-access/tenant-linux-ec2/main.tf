locals {
  namespace = "${var.app}-${var.env}"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("${path.module}/.ssh/id_rsa.pub")
}

resource "aws_instance" "linux-instance" {
  ami           = "ami-0ccabb5f82d4c9af5" #AMI id available to us-east-2
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key.key_name

  //name of ec2 instance
  tags = {
    Name = "${local.namespace}-ec2-linux"
  }
  //set role/permissions on what ec2 instance can do
  iam_instance_profile = aws_iam_instance_profile.ec2_linux_profile.name
}
