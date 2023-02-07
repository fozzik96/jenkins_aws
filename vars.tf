variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "root_volume_size" {
  type        = string
  description = "EC2 instance root volume size in Gb"
}

variable "root_volume_type" {
  type        = string
  description = "Ec2 instance root volume  type"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "jenkins_ports" {
  type        = list(any)
  description = "Ports for Jenkins Web Server"
}

variable "tags" {
  description = "Tags to apply to Resources"
  type        = map(any)
}

variable "key_pair" {
  description = "Name of Key Pair"
  type        = string
  sensitive   = true
}

variable "pass_the_build" {
  description = "Check if you are the robot - enter any three symbols"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.pass_the_build) == 3
    error_message = "You are a robot"
  }
}

variable "server_settings" {
  type = map(any)
  default = {
    web = {
      instance_type = "t3.small"
      root_disksize = 20
      encrypted     = true
    }
    jenkins = {
      instance_type = "t2.micro"
      root_disksize = 30
      encrypted     = false
    }
  }
}