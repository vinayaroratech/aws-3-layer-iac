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

variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
  type        = string
}

variable "owner" {
  description = "Account to use for EC2 AMI"
  type        = string
  default     = "875735646846"
}