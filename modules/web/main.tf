# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  # insert the 10 required variables here
  name                   = "${var.project}-${terraform.workspace}-bh"
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  subnet_id              = var.vpc.public_subnets[0]
  vpc_security_group_ids = [var.sg.web_server_sg]
  tags                   = var.common_tags
}

# Create Elastic IP for Bastion Host
# Resource - depends_on Meta-Argument
resource "aws_eip" "bastion_eip" {
  depends_on = [module.ec2_public, var.vpc]
  instance   = module.ec2_public.id[0]
  vpc        = true
  tags       = var.common_tags
}

# Create a Null Resource and Provisioners
resource "null_resource" "name" {
  # Changes to any instance of the cluster requires re-provisioning
  depends_on = [module.ec2_public]

  triggers = {
    instance_public_ip = aws_eip.bastion_eip.public_ip
    private_key        = file(".\\private-key\\${var.instance_keypair}.pem")
  }

  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type        = "ssh"
    host        = self.triggers.instance_public_ip #aws_eip.bastion_eip.public_ip
    user        = "ubuntu"
    password    = ""
    private_key = self.triggers.private_key
    agent    = "false"
  }

  # Copies the ${var.instance_keypair}.pem file to /tmp/${var.instance_keypair}.pem
  provisioner "file" {
    source      = ".\\private-key\\${var.instance_keypair}.pem"
    destination = "/var/tmp/${var.instance_keypair}.pem"
  }

  # Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "mv /var/tmp/${var.instance_keypair}.pem /tmp/${var.instance_keypair}.pem",
      "sudo chmod 400 /tmp/${var.instance_keypair}.pem"
    ]
  }
  # local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command     = "echo VPC created on `date` and VPC ID: ${var.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
    #on_failure = continue
  }
  ## Local Exec Provisioner:  local-exec provisioner (Destroy-Time Provisioner - Triggered during deletion of Resource)
  provisioner "local-exec" {
    command     = "echo Destroy time prov `date` >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when        = destroy
    #on_failure = continue
  }
}