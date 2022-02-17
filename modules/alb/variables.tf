variable "name" {
  type = string
}

variable "common_tags" {
  type = any
}

variable "vpc" {
  type = any
}

variable "loadbalancer_sg" {
  type = any
}

variable "ec2_private_instance_ids" {
  type = any
}
