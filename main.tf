provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

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

resource "aws_instance" "my_ubuntu" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.jenkins_web.id]
  user_data_replace_on_change = true
  user_data                   = file("user_data.sh")
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }
  key_name = "jenkins-key"
  tags = {
    Name    = "My-UbuntuLinux-Server-Jenkins"
    Owner   = "Kirill Pavlov"
    project = "Education"
  }
}

resource "aws_eip" "jenkins" {
  vpc      = true # Need to be added in new versions of AWS Provider
  instance = aws_instance.my_ubuntu.id
  tags = {
    Name  = "EIP for Jenkins Built by Terraform"
    Owner = "Kirill Pavlov"
  }
}

resource "aws_security_group" "jenkins_web" {
  name        = "Dynamic-Blocks-SG"
  description = "Security Group built by Dynamic Blocks"
  vpc_id      = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  dynamic "ingress" {
    for_each = ["80", "8080", "443", "8843"]
    content {
      description = "Allow port HTTP"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = ["80", "8080", "443", "8843"]
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
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Dynamic Block SG by Terraform"
    Owner = "Kirill Pavlov"
  }
}