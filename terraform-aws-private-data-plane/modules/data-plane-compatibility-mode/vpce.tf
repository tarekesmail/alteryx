
resource "aws_vpc_endpoint" "endpoint" {
  for_each          = local.VPC_ENDPOINTS
  vpc_id            = data.aws_vpc.selected.id
  service_name      = each.key
  vpc_endpoint_type = each.value
  security_group_ids = [
    aws_security_group.compatibility_mode.id,
  ]

  private_dns_enabled = true
  tags                = local.TAGS
  subnet_ids          = data.aws_subnets.selected.ids
}
