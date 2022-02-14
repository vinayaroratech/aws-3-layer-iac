module "networking" {
  source                = "./modules/networking"
  project               = var.project
  vpc_cidr              = var.vpc_cidr
  private_subnets_cidr  = var.private_subnets_cidr
  public_subnets_cidr   = var.public_subnets_cidr
  database_subnets_cidr = var.database_subnets_cidr
  azs                   = var.azs
  common_tags           = local.common_tags
}

module "app" {
  source           = "./modules/app"
  project          = var.project
  instance_keypair = var.instance_keypair
  owner            = var.owner

  vpc = module.networking.vpc
  sg  = module.networking.sg
  # db_config = module.database.db_config
  common_tags = local.common_tags
}

module "web" {
  source           = "./modules/web"
  project          = var.project
  instance_keypair = var.instance_keypair
  owner            = var.owner

  vpc         = module.networking.vpc
  sg          = module.networking.sg
  common_tags = local.common_tags
}