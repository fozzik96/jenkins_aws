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



