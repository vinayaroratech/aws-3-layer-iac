variable "project" {
  description = "The project to use for unique resource naming"
  default     = "symba"
  type        = string
}

variable "ssh_keypair" {
  description = "SSH keypair to use for EC2 instance"
  default     = "symba-terraform-keypair"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
  type        = string
}

variable "owner" {
  description = "Account to use for EC2 AMI"
  type        = string
  default     = "875735646846"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnets_cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets_cidr" {
  type    = list(any)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "database_subnets_cidr" {
  type    = list(any)
  default = ["10.0.151.0/24", "10.0.152.0/24"]
}

variable "azs" {
  type    = list(any)
  default = ["ap-south-1a", "ap-south-1b"]
}
