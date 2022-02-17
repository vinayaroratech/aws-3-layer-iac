module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version         = "2.78.0"
  name            = "${var.project}-vpc"
  cidr            = var.vpc_cidr
  azs             = var.azs
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
    Name        = "${var.project}-vpc"
    Environment = "${terraform.workspace}"
  }
  public_subnet_tags = {
    Name        = "${var.project}-${terraform.workspace}-public"
    Environment = "${terraform.workspace}"
    Type        = "public-subnets"
  }
  private_subnet_tags = {
    Name        = "${var.project}-${terraform.workspace}-private"
    Environment = "${terraform.workspace}"
    Type        = "private-subnets"
  }

  database_subnet_tags = {
    Name        = "${var.project}-${terraform.workspace}-database"
    Environment = "${terraform.workspace}"
    Type        = "database-subnets"
  }
}

# Security Group for Public Bastion Host
module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name        = "public-bastion-sg"
  description = "Security group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id
  # Ingress Rules & CIDR Block  
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = var.common_tags
}

# Security Group for Private EC2 Instances
module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name                = "private-sg"
  description         = "Security group with HTTP & SSH ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id              = module.vpc.vpc_id
  ingress_rules       = ["ssh-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  tags                = var.common_tags
}

# Security Group for Public Load Balancer
module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name        = "loadbalancer-sg"
  description = "Security group with HTTP port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id
  # Ingress Rules & CIDR Block  
  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = var.common_tags
}