data "aws_vpc" "default" {
  default = true
}

data "aws_region" "current" {}

data "aws_ami" "amazonlinux2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami*-hvm-*-x86_64-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

}

locals {
  region = var.aws_region

  region_az_list = [
    "${var.aws_region}a",
    "${var.aws_region}b"
  ]

}
