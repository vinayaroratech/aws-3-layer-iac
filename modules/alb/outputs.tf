# Terraform AWS Application Load Balancer (ALB) Outputs
output "alb" {
  value = {
    # The ID and ARN of the load balancer we created.
    lb_id = module.alb.this_lb_id
    # The ID and ARN of the load balancer we created.
    lb_arn = module.alb.this_lb_arn
    # The DNS name of the load balancer.
    lb_dns_name = module.alb.this_lb_dns_name
    # ARN suffix of our load balancer - can be used with CloudWatch.
    lb_arn_suffix = module.alb.this_lb_arn_suffix
    # The zone_id of the load balancer to assist with creating DNS records.
    lb_zone_id = module.alb.this_lb_zone_id
    # The ARN of the TCP and HTTP load balancer listeners created.
    http_tcp_listener_arns = module.alb.http_tcp_listener_arns
    # The IDs of the TCP and HTTP load balancer listeners created.
    http_tcp_listener_ids = module.alb.http_tcp_listener_ids
    # The ARNs of the HTTPS load balancer listeners created.
    https_listener_arns = module.alb.https_listener_arns
    # The IDs of the load balancer listeners created.
    https_listener_ids = module.alb.https_listener_ids
    # ARNs of the target groups. Useful for passing to your Auto Scaling group.
    target_group_arns = module.alb.target_group_arns
    # ARN suffixes of our target groups - can be used with CloudWatch.
    target_group_arn_suffixes = module.alb.target_group_arn_suffixes
    # Name of the target group. Useful for passing to your CodeDeploy Deployment Group.
    target_group_names = module.alb.target_group_names
    # ARNs of the target group attachment IDs.
    target_group_attachments = module.alb.target_group_attachments
  }
}