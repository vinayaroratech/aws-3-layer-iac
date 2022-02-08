data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/app_config.yaml", var.db_config)
  }
}

# data "aws_ami" "ubuntu" {
#   most_recent = true
#   filter {
#     name = "name"
#     values = [
#     "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
#   }
#   filter {
#     name = "virtualization-type"
#     values = [
#     "hvm"]
#   }
#   owners = [var.owner]
# }

resource "aws_launch_template" "appserver" {
  name_prefix            = var.project
  image_id               = "ami-0e6b0a17afac0450f" #data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  user_data              = data.cloudinit_config.config.rendered
  key_name               = var.ssh_keypair
  vpc_security_group_ids = [var.sg.app_server_sg]
}

resource "aws_autoscaling_group" "appserver" {
  name                = "${var.project}-app-asg"
  min_size            = 1
  max_size            = 3
  vpc_zone_identifier = var.vpc.private_subnets
  target_group_arns   = module.app_alb.target_group_arns
  launch_template {
    id      = aws_launch_template.appserver.id
    version = aws_launch_template.appserver.latest_version
  }
}

module "app_alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 5.0"
  name               = "${var.project}--app-alb"
  load_balancer_type = "application"
  vpc_id             = var.vpc.vpc_id
  subnets            = var.vpc.private_subnets
  security_groups    = [var.sg.app_alb_sg]

  http_tcp_listeners = [
    {
      port               = 80,
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name_prefix      = "appsvr",
      backend_protocol = "HTTP",
      backend_port     = 80
      target_type      = "instance"
    }
  ]
}

