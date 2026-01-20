# ------------------------------
# Web Server Outputs
# ------------------------------
output "web_server_public_ip" {
  description = "Public IP of the Web Server"
  value       = aws_instance.web_server.public_ip
}

output "web_server_private_ip" {
  description = "Private IP of the Web Server"
  value       = aws_instance.web_server.private_ip
}

output "web_server_eip" {
  description = "Elastic IP associated with Web Server"
  value       = aws_eip.web_server_eip.public_ip
}

# ------------------------------
# Ansible Controller Outputs
# ------------------------------
output "ansible_controller_private_ip" {
  description = "Private IP of the Ansible Controller"
  value       = aws_instance.ansible_controller.private_ip
}

# ------------------------------
# Monitoring Server Outputs
# ------------------------------
output "monitoring_server_private_ip" {
  description = "Private IP of the Monitoring Server"
  value       = aws_instance.monitoring_server.private_ip
}

# ------------------------------
# VPC and Subnet Outputs
# ------------------------------
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.devops.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.private.id
}
