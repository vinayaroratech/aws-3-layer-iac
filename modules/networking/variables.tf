variable "project" {
  type = string
}

variable "azs" {
  type = list(any)
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnets_cidr" {
  type = list(any)
}

variable "public_subnets_cidr" {
  type = list(any)
}

variable "database_subnets_cidr" {
  type = list(any)
}

variable "common_tags" {
  type = any
}