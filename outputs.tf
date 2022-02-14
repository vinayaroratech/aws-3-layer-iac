# Private EC2 Instances
output "ec2_bastion_public_instance_ids" {
  description = "List of IDs of instances"
  value       = module.web.ec2_bastion_public_instance_ids
}
output "ec2_bastion_public_ip" {
  description = "List of public ip address assigned to the instances"
  value       = module.web.ec2_bastion_public_ip
}

# Private EC2 Instances
output "ec2_private_instance_ids" {
  description = "List of IDs of instances"
  value       = module.app.ec2_private_instance_ids
}
output "ec2_private_ip" {
  description = "List of private ip address assigned to the instances"
  value       = module.app.ec2_private_ip
}