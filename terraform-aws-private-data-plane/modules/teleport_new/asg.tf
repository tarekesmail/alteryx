
resource "aws_launch_template" "teleport" {
  # name_prefix = "${var.resource_name}-${var.name}-"
  name     = "${var.resource_name}-${var.name}"
  image_id = local.TELEPORT_SELECTED_AMI
  # Should select from region map in locals line 62
  instance_type = local.teleport_instance_type

  instance_initiated_shutdown_behavior = "terminate"

  update_default_version = true

  vpc_security_group_ids = [var.eks_security_group_id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.teleport.arn
  }

  user_data = base64encode(templatefile("${path.module}/teleport/init_script.sh.tftpl",
    {
      json_content = local.platform_json_content
      AYX_ETC      = "/etc/ayx"
      AYX_HOME     = "/opt/ayx"
      AYX_LOG      = "/var/log/ayx"
    }
    )
  )

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }

  tags = local.TAGS

}

resource "aws_autoscaling_group" "teleport" {
  # name_prefix   = "${var.resource_name}-${var.name}-"
  name = "${var.resource_name}-${var.name}"

  max_size = var.TELEPORT_AWS_AUTOSCALING.max_size
  min_size = var.TELEPORT_AWS_AUTOSCALING.min_size

  launch_template {
    id      = aws_launch_template.teleport.id
    version = aws_launch_template.teleport.latest_version
  }

  vpc_zone_identifier = data.aws_subnets.selected.ids

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 100
    }
  }

  depends_on = [module.teleport_ami]
}


resource "aws_vpc_security_group_egress_rule" "teleport_agent" {
  ip_protocol       = -1
  security_group_id = var.eks_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
}

