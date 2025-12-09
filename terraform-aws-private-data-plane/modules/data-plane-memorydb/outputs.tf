output "redis_endpoint" {
  description = "Redis cluster endpoint URL."
  value       = aws_memorydb_cluster.memorydb_cluster.cluster_endpoint[0].address
}

output "redis_username" {
  description = "Redis username."
  value       = aws_memorydb_user.memorydb_user.user_name
}

output "redis_password" {
  description = "Redis password (sensitive)."
  value       = random_password.memorydb_password.result
  sensitive   = true
}

output "redis_port" {
  description = "The port used by the memorydb cluster"
  value       = local.memorydb_port
}

output "memorydb_security_group_id" {
  description = "The ID of the MemoryDB security group"
  value       = aws_security_group.memorydb_sg.id
}