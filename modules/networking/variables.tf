variable "project" {
  type = string
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