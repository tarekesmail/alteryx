output "coredns_private_ip" {
  description = "The private IP assigned to the CoreDNS ENI."
  value       = aws_network_interface.coredns_eni.private_ip
}

output "vpc_resolver_ip" {
  description = "The VPC resolver IP address."
  value       = local.vpc_resolver_ip
}