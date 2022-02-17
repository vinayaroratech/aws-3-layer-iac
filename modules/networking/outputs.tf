output "vpc" {
  value = module.vpc
}

output "sg" {
  value = {
    web_server_sg        = module.public_bastion_sg.this_security_group_id
    web_server_sg_vpc_id = module.public_bastion_sg.this_security_group_vpc_id
    web_server_sg_name   = module.public_bastion_sg.this_security_group_name
    app_server_sg        = module.private_sg.this_security_group_id
    app_server_sg_vpc_id = module.private_sg.this_security_group_vpc_id
    app_server_sg_name   = module.private_sg.this_security_group_name
  }
}

output "loadbalancer_sg" {
  value = {
    alb_sg_id = module.loadbalancer_sg.this_security_group_id
  }
}