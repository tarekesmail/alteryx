# Define 4 network interfaces as this is Bridge Proxy Manager requirement
# resource "aws_network_interface" "bridge_proxy_manager_interfaces" {
#   count         = 4
#   subnet_id     = element(data.aws_subnets.selected.ids, count.index)
#   security_groups = [aws_security_group.bridge_proxy_manager.id]

#   tags = merge(local.TAGS, { "Name" = "${var.resource_name}-${var.name}-nic-${count.index + 1}" })
# }

resource "aws_launch_template" "bridge_proxy_manager_lt" {
  name     = local.full_name
  image_id = local.BPM_SELECTED_AMI

  # Use the first value as preferred value
  instance_type = [for v in var.BPM_AWS_AUTOSCALING.instance_types : v if contains(data.aws_ec2_instance_types.bridge-proxy-manager.instance_types, v)][0]

  instance_initiated_shutdown_behavior = "terminate"
  update_default_version               = true

  # Attach network interfaces
  dynamic "network_interfaces" {
    for_each = range(var.eni_count)
    content {
      device_index          = network_interfaces.key
      delete_on_termination = true
      subnet_id             = element(data.aws_subnets.selected.ids, network_interfaces.key)
      security_groups       = [aws_security_group.bridge_proxy_manager_sg.id]

      # Assign 14 additional private IPs (1 primary + 14 secondary = 15 total)
      ipv4_address_count = 14
    }
  }

  # IAM instance profile
  iam_instance_profile {
    name = aws_iam_instance_profile.bridge_proxy_manager_profile.name
  }

  # User data for initialization script
  user_data = base64encode(templatefile("${path.module}/scripts/init_script.sh.tftpl",
    {
      json_content = local.platform_json_content
      AYX_ETC      = "/etc/ayx"
      AYX_HOME     = "/opt/ayx"
      AYX_LOG      = "/var/log/ayx"
    }
  ))

  # Tag specifications
  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }

  tags = local.TAGS
}

resource "aws_autoscaling_group" "bridge_proxy_manager_asg" {
  name = local.full_name

  desired_capacity = var.BPM_AWS_AUTOSCALING.desired_capacity
  max_size         = var.BPM_AWS_AUTOSCALING.max_size
  min_size         = var.BPM_AWS_AUTOSCALING.min_size

  launch_template {
    id      = aws_launch_template.bridge_proxy_manager_lt.id
    version = aws_launch_template.bridge_proxy_manager_lt.latest_version
  }

  vpc_zone_identifier = data.aws_subnets.selected.ids
  initial_lifecycle_hook {
    name                 = "lifecycle-hook"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 30
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  }


  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 100
    }
  }

  depends_on = [module.bridge_proxy_manager_ami]
}

resource "aws_security_group" "bridge_proxy_manager_sg" {
  name        = "${local.full_name}-sg"
  description = "Allow HTTP inbound and all outbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  # Allow internal VPC traffic on all ports
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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
  from = aws_security_group_rule.allow_bpm_to_memorydb
  to   = aws_security_group_rule.allow_bpm_to_memorydb[0]
}

resource "aws_security_group_rule" "allow_bpm_to_memorydb" {
  count = var.enable_memorydb ? 1 : 0

  type                     = "ingress"
  from_port                = 6378 # Default Redis port
  to_port                  = 6378
  protocol                 = "tcp"
  security_group_id        = var.memorydb_security_group_id
  source_security_group_id = aws_security_group.bridge_proxy_manager_sg.id
  description              = "Allow traffic from BPM to MemoryDB"
}
