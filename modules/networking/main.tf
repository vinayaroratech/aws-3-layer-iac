data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version         = "2.78.0"
  name            = "${var.project}-vpc"
  cidr            = var.vpc_cidr
  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr

  # Database Subnets
  create_database_subnet_group       = true
  create_database_subnet_route_table = true
  database_subnets                   = var.database_subnets_cidr

  #create_database_nat_gateway_route = true
  #create_database_internet_gateway_route = true

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = true
  single_nat_gateway = true

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Project     = var.project
    Environment = "${terraform.workspace}"
  }
  vpc_tags = {
    Name        = var.project
    Environment = "${terraform.workspace}"
  }
  public_subnet_tags = {
    Name        = var.project
    Environment = "${terraform.workspace}"
    Type        = "public-subnets"
  }
  private_subnet_tags = {
    Name        = var.project
    Environment = "${terraform.workspace}"
    Type        = "private-subnets"
  }

  database_subnet_tags = {
    Name        = var.project
    Environment = "${terraform.workspace}"
    Type        = "database-subnets"
  }
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
      rule        = "ssh-tcp"
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
    },
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.web_server_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 2
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
      rule                     = "postgresql-tcp"
      source_security_group_id = module.app_server_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}

