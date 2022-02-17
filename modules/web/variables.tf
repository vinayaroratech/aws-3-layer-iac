variable "project" {
  type = string
}

variable "instance_keypair" {
  type = string
}

variable "vpc" {
  type = any
}

variable "sg" {
  type = any
}

variable "common_tags" {
  type = any
}

variable "owner" {
  description = "Account to use for EC2 AMI"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.medium"
}


variable "ami" {
  description = "EC2 AMI"
  type        = string
  default     = "ami-0bd586d26693ecbe9"
}