# Define Local Values in Terraform
locals {
  owners      = var.project
  environment = terraform.workspace
  #name = "${var.business_divsion}-${var.environment}"
  name = "${local.owners}-${local.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
} 