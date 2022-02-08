data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/web_config.yaml", {})
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

resource "aws_launch_template" "webserver" {
  name_prefix            = var.project
  image_id               = "ami-0e6b0a17afac0450f" #data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  user_data              = data.cloudinit_config.config.rendered
  key_name               = var.ssh_keypair
  vpc_security_group_ids = [var.sg.web_server_sg]
}

resource "aws_autoscaling_group" "webserver" {
  name                = "${var.project}-web-asg"
  min_size            = 1
  max_size            = 3
  vpc_zone_identifier = var.vpc.public_subnets
  target_group_arns   = module.web_alb.target_group_arns
  launch_template {
    id      = aws_launch_template.webserver.id
    version = aws_launch_template.webserver.latest_version
  }
}

module "web_alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 5.0"
  name               = "${var.project}--web-alb"
  load_balancer_type = "application"
  vpc_id             = var.vpc.vpc_id
  subnets            = var.vpc.public_subnets
  security_groups    = [var.sg.web_alb_sg]

  http_tcp_listeners = [
    {
      port               = 80,
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name_prefix      = "websvr",
      backend_protocol = "HTTP",
      backend_port     = 80
      target_type      = "instance"
    }
  ]
}

