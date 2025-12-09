
resource "aws_launch_template" "starayx" {
  # name_prefix = "${var.resource_name}-${var.name}-"
  name     = "${var.resource_name}-${var.name}"
  image_id = local.STARAYX_SELECTED_AMI

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 30
      volume_type = "gp3"
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  // use the first value as preferred value
  instance_type = [for v in var.STARAYX_AWS_AUTOSCALING.instance_types : v if contains(data.aws_ec2_instance_types.starayx.instance_types, v)][0]

  instance_initiated_shutdown_behavior = "terminate"

  update_default_version = true

  vpc_security_group_ids = compact([
    aws_security_group.starayx.id,
    var.allow_eks_traffic_sg_id,
    var.enable_memorydb ? aws_security_group.starayx_to_redis[0].id : null
  ])

  iam_instance_profile {
    arn = aws_iam_instance_profile.starayx.arn
  }

  user_data = base64encode(templatefile("${path.module}/starayx-client/init_script.sh.tftpl",
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

resource "aws_autoscaling_group" "starayx" {
  # name_prefix   = "${var.resource_name}-${var.name}-"
  name = "${var.resource_name}-${var.name}"

  desired_capacity = var.STARAYX_AWS_AUTOSCALING.desired_capacity
  max_size         = var.STARAYX_AWS_AUTOSCALING.max_size
  min_size         = var.STARAYX_AWS_AUTOSCALING.min_size

  launch_template {
    id      = aws_launch_template.starayx.id
    version = aws_launch_template.starayx.latest_version
  }

  vpc_zone_identifier = data.aws_subnets.selected.ids

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 100
    }
  }

  depends_on = [module.starayx_ami, module.secrets]
}

resource "aws_security_group" "starayx" {
  name_prefix = "${var.resource_name}-${var.name}-"
  description = "Allow TLS inbound / outbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.TAGS
}