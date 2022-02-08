variable "project" {
  type = string
}

variable "ssh_keypair" {
  type = string
}

variable "vpc" {
  type = any
}

variable "sg" {
  type = any
}

variable "owner" {
  description = "Account to use for EC2 AMI"
  type        = string
}