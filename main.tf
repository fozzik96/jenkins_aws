provider "aws" {
  region = var.aws_region
}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins_main" {
  for_each                    = var.server_settings
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = each.value["instance_type"]
  vpc_security_group_ids      = [aws_security_group.jenkins_web.id]
  user_data_replace_on_change = true
  user_data                   = file("user_data.sh")
  root_block_device {
    volume_size = each.value["root_disksize"]
    volume_type = var.root_volume_type
    encrypted   = each.value["encrypted"]
  }
  lifecycle {
    create_before_destroy = true
  }
  key_name = var.key_pair
  tags     = merge(var.tags, { Name = "${var.tags["Environment"]}-My-UbuntuLinux-Server-${each.key}" })
}

resource "aws_eip" "jenkins" {
  vpc      = true # Need to be added in new versions of AWS Provider
  instance = aws_instance.jenkins_main["web"].id
  tags     = merge(var.tags, { Name = "${var.tags["Environment"]}-EIP for WebServer Built by Terraform" }, local.tags_for_eip)
}

resource "aws_security_group" "jenkins_web" {
  name        = "Dynamic-Blocks-SG"
  description = "Security Group for my ${var.tags["Environment"]} Jenkins Server"
  vpc_id      = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  dynamic "ingress" {
    for_each = var.jenkins_ports
    content {
      description = "Allow port HTTP"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = var.jenkins_ports
    content {
      description = "Allow port UDP"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "Allow port SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "Dynamic Block SG by Terraform" })
}

locals {
  region_fullname = data.aws_region.current.description
  number_of_azs   = length(data.aws_availability_zones.available.names)
}

locals {

}

locals {
  tags_for_eip = {
    Environment = var.tags["Environment"]
  }
}
