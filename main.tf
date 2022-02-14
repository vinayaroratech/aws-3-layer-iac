module "networking" {
  source                = "./modules/networking"
  project               = var.project
  vpc_cidr              = var.vpc_cidr
  private_subnets_cidr  = var.private_subnets_cidr
  public_subnets_cidr   = var.public_subnets_cidr
  database_subnets_cidr = var.database_subnets_cidr
}

module "database" {
  source  = "./modules/database"
  project = var.project

  vpc = module.networking.vpc
  sg  = module.networking.sg
}

module "app" {
  source      = "./modules/app"
  project     = var.project
  ssh_keypair = var.ssh_keypair
  owner       = var.owner

  vpc       = module.networking.vpc
  sg        = module.networking.sg
  db_config = module.database.db_config
}

module "web" {
  source      = "./modules/web"
  project     = var.project
  ssh_keypair = var.ssh_keypair
  owner       = var.owner

  vpc = module.networking.vpc
  sg  = module.networking.sg
}
