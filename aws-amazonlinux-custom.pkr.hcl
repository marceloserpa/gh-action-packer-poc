variable "version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

locals {
  ami_name = "custom-al2023"
  region = "us-east-1"
  base_ami = "ami-051f8a213df8bc089"
}

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
  
source "amazon-ebs" "custom-os-al2023" {
  ami_name      = "${local.ami_name}-ami-${var.version}"
  instance_type = "t2.micro"
  region        = "${local.region}"
  source_ami  = "${local.base_ami}"

  vpc_id = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"

  associate_public_ip_address = true

  ssh_username = "ec2-user"
  
  tags = {
    Name = "${ami_name}"
    Version = "${var.version}"
  }  

}

build {
  name    = "packer-bake-ami"
  sources = [
    "source.amazon-ebs.custom-os-al2023"
  ]

  provisioner "shell" {
    script = "./install.sh"
  }

}
