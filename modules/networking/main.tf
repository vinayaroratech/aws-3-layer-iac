data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version          = "2.64.0"
  name             = "${var.project}-vpc"
  cidr             = "10.0.0.0/16"
  azs              = data.aws_availability_zones.available.names
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  create_database_subnet_group = true
  enable_nat_gateway           = false
  single_nat_gateway           = false
}

module "web_alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "web-alb-sg"
  description = "Security group for web tier app load balancer in VPC"
  vpc_id      = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "web-server-sg"
  description = "Security group for web servers in VPC"
  vpc_id      = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.web_alb_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}

module "app_alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "app-alb-sg"
  description = "Security group for app tier alb in VPC"
  vpc_id      = module.vpc.vpc_id
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.web_server_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}

module "app_server_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "app-server-sg"
  description = "Security group for app servers in VPC"
  vpc_id      = module.vpc.vpc_id
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.app_alb_sg.security_group_id
    },
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.web_server_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 2
}

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db-sg"
  description = "Security group for db servers in VPC"
  vpc_id      = module.vpc.vpc_id
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.app_server_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}

