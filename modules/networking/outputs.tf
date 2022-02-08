output "vpc" {
  value = module.vpc
}

output "sg" {
  value = {
    web_alb_sg    = module.web_alb_sg.security_group_id
    web_server_sg = module.web_server_sg.security_group_id
    app_alb_sg    = module.app_alb_sg.security_group_id
    app_server_sg = module.app_server_sg.security_group_id
    db_sg         = module.db_sg.security_group_id
  }
}
