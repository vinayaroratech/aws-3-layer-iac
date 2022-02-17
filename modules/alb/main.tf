# Terraform AWS Application Load Balancer (ALB)
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.16.0"

  name               = "${var.name}-alb"
  load_balancer_type = "application"
  vpc_id             = var.vpc.vpc_id
  subnets = [
    var.vpc.public_subnets[0],
    var.vpc.public_subnets[1]
  ]
  security_groups = [var.loadbalancer_sg.alb_sg_id]
  # Listeners
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
  # Target Groups
  target_groups = [
    # App1 Target Group
    {
      name_prefix      = "app1-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      # App1 Target Group - Targets
      targets = {
        my_app1_vm1 = {
          target_id = var.ec2_private_instance_ids[0]
          port      = 80
        },
        my_app1_vm2 = {
          target_id = var.ec2_private_instance_ids[1]
          port      = 80
        }
      }
      tags = var.common_tags # Target Group Tags
    }
  ]
  tags = var.common_tags # ALB Tags
}
