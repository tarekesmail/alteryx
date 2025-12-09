output "bridge_proxy_manager_sg" {
  description = "The ID of the bpm security group"
  value       = aws_security_group.bridge_proxy_manager_sg.id
}
