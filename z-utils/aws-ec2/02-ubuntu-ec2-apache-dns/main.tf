###
###---to remotely connect to EC2 using SSH
### Once terraform script gets executed, the .pem file gets created
### >chmod 600 ./ubuntu-test-server-key.pem
### >ssh -i "ubuntu-test-server-key.pem" ubuntu@ec2-54-84-104-127.compute-1.amazonaws.com

locals {
  hosted_zone_name = "rnd.zone"
  domain_name      = "rnd.zone"
}

#NOTE: using existing hosted zone (which is configured with domain registrar / nameservers)
data "aws_route53_zone" "dns_zone" {
  private_zone = false
  name         = local.hosted_zone_name
}

#Create EC2 Web Instance
module "ec2-web-instance" {
  source      = "./ec2-web-instance"
  domain_name = local.domain_name
  zone_id     = data.aws_route53_zone.dns_zone.id
  vpc_id      = "vpc-5198da29"
}

