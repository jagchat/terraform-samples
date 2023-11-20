variable "domain_name" {}
variable "zone_id" {}
variable "vpc_id" {}
locals {
  ec2name = "ubuntu-test-server"
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_instance" "server-instance" {
  #ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20231117 from https://cloud-images.ubuntu.com/locator/
  ami                         = "ami-0b2a9065573b0a9c9"
  instance_type               = "t2.micro"
  key_name                    = "${local.ec2name}-key"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.server-sg.id]
  user_data                   = filebase64("${path.module}/ec2-startup-script.sh")

  #   user_data = <<EOF
  # #!/usr/bin/env bash
  # exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
  # echo BEGIN
  # sudo apt update
  # sudo apt install -y unzip
  # echo END  
  #   EOF

  # root disk
  root_block_device {
    volume_size           = 64
    delete_on_termination = true
  }

  //name of ec2 instance
  tags = {
    Name = "${local.ec2name}"
  }
  //set role/permissions on what ec2 instance can do
  iam_instance_profile = aws_iam_instance_profile.ec2_server_profile.name
}

# Define the security group for the server
resource "aws_security_group" "server-sg" {
  name        = "${local.ec2name}-sg"
  description = "Allow incoming connections"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_route53_record" "ubuntu-test-server-record" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = [aws_instance.server-instance.public_ip]
}
