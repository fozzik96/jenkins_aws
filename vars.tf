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
  default     = "30"
  description = "EC2 instance root volume size in Gb"
}

variable "root_volume_type" {
  type        = string
  default     = "gp2"
  description = "Ec2 instance root volume  type"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "jenkins_ports" {
  type        = list(any)
  default     = ["80", "8080", "443", "8843"]
  description = "Ports for Jenkins Web Server"
}

variable "tags" {
  description = "Tags to apply to Resources"
  type        = map(any)
  default = {
    Owner       = "Kirill Pavlov"
    Project     = "Education"
    Environment = "Production"
  }
}

variable "key_pair" {
  description = "Name of Key Pair"
  type        = string
  default     = "jenkins-key"
  sensitive   = true
}

variable "pass_the_build" {
  description = "Check if you are the robot - enter any three number"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.pass_the_build) == 3
    error_message = "You are a robot"
  }
}