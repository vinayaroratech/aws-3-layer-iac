# EC2 Instances that will be created in VPC Private Subnets
module "ec2_private" {
  depends_on             = [var.vpc]
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "2.17.0"
  name                   = "${var.project}-${terraform.workspace}-vm"
  ami                    = var.ami
  instance_type          = var.instance_type
  user_data              = file("${path.module}/apache-install.sh")
  key_name               = var.instance_keypair
  vpc_security_group_ids = [var.sg.app_server_sg]
  instance_count         = 4
  #subnet_id = module.vpc.private_subnets[0] # Single Instance
  subnet_ids = var.vpc.private_subnets
  tags       = var.common_tags
}