resource "aws_network_interface" "coredns_eni" {
  subnet_id       = data.aws_subnets.selected.ids[0] # Specify the subnet
  security_groups = [aws_security_group.coredns_sg.id]

  tags = merge(local.TAGS, { Name = "${local.full_name}-eni" })
}

resource "aws_instance" "coredns_instance" {
  ami           = local.COREDNS_SELECTED_AMI
  instance_type = var.instance_type

  # Attach the ENI created earlier
  network_interface { # network_interface block is deprecated
    network_interface_id = aws_network_interface.coredns_eni.id
    device_index         = 0
  }
  root_block_device {
    encrypted = true
  }

  iam_instance_profile = aws_iam_instance_profile.coredns_profile.name

  # User data for initialization script
  user_data = base64encode(templatefile("${path.module}/scripts/init_script.sh.tftpl",
    {
      json_content = local.platform_json_content
      AYX_ETC      = "/etc/ayx"
      AYX_HOME     = "/opt/ayx"
      AYX_LOG      = "/var/log/ayx"
    }
  ))

  tags = merge(local.TAGS, { Name = local.full_name })
}

resource "aws_security_group" "coredns_sg" {
  name        = "${local.full_name}-sg"
  description = "Allow HTTP inbound and all outbound traffic"
  vpc_id      = data.aws_vpc.selected.id
  # Ingress rule for TCP on port 53
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [for assoc in data.aws_vpc.selected.cidr_block_associations : assoc.cidr_block]
  }

  # Ingress rule for UDP on port 53
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [for assoc in data.aws_vpc.selected.cidr_block_associations : assoc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.TAGS
}

moved {
  from = aws_security_group_rule.allow_coredns_to_memorydb
  to   = aws_security_group_rule.allow_coredns_to_memorydb[0]
}

resource "aws_security_group_rule" "allow_coredns_to_memorydb" {
  count = var.enable_memorydb ? 1 : 0

  type                     = "ingress"
  from_port                = 6378 # Default Redis port
  to_port                  = 6378
  protocol                 = "tcp"
  security_group_id        = var.memorydb_security_group_id
  source_security_group_id = aws_security_group.coredns_sg.id
  description              = "Allow traffic from CoreDNS to MemoryDB"
}
