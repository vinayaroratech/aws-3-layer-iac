module "networking" {
  source                = "./modules/networking"
  project               = var.project
  vpc_cidr              = var.vpc_cidr
  private_subnets_cidr  = var.private_subnets_cidr
  public_subnets_cidr   = var.public_subnets_cidr
  database_subnets_cidr = var.database_subnets_cidr
  azs                   = var.azs
}