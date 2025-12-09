resource "aws_security_group" "starayx_to_redis" {
  count       = var.enable_memorydb ? 1 : 0
  name        = "${var.resource_name}-starayx-to-redis-sg"
  description = "Security group for starayx instances accessing MemoryDB"
  vpc_id      = data.aws_vpc.selected.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.TAGS
}

resource "aws_security_group_rule" "allow_starayx_to_memorydb" {
  count                    = var.enable_memorydb ? 1 : 0
  type                     = "ingress"
  from_port                = 6378
  to_port                  = 6378
  protocol                 = "tcp"
  security_group_id        = var.memorydb_security_group_id
  source_security_group_id = aws_security_group.starayx_to_redis[0].id
  description              = "Allow starayx instances to access MemoryDB"
}