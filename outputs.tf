output "db_password" {
  value     = module.database.db_config.password
  sensitive = true
}

output "web_alb_dns_name" {
  value = module.web.alb_dns_name
}

output "app_alb_dns_name" {
  value = module.app.alb_dns_name
}
