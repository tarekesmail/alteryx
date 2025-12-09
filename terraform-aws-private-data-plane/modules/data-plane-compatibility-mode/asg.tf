resource "aws_launch_template" "compatibility_mode" {
  name          = local.cefd_resource_name
  image_id      = local.CLOUD_EXECUTION_SELECTED_AMI
  instance_type = local.cefd_instance_type

  instance_initiated_shutdown_behavior = "terminate"

  update_default_version = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.compatibility_mode.arn
  }
  user_data = base64encode(replace(var.user_data, "__AYX_RESOURCE_PLACEHOLDER__", var.resource_name))

  tags = local.TAGS

  tag_specifications {
    resource_type = "instance"

    tags = {
      autoscaling_groupName = local.cefd_resource_name
    }
  }
}

resource "aws_autoscaling_group" "compatibility_mode" {
  name             = local.cefd_resource_name
  desired_capacity = local.ENABLE_CEFD_SCALING ? 0 : 2
  max_size         = max(var.CLOUD_EXECUTION_MAX_SCALING, 2)
  min_size         = local.ENABLE_CEFD_SCALING ? 0 : 1
  launch_template {
    id      = aws_launch_template.compatibility_mode.id
    version = aws_launch_template.compatibility_mode.latest_version
  }
  vpc_zone_identifier = data.aws_subnets.selected.ids
  initial_lifecycle_hook {
    name                 = "lifecycle-hook"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 30
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  }
  dynamic "tag" {
    for_each = [for k, v in local.TAGS : {
      key   = k
      value = v
    }]
    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = false
    }
  }
  depends_on = [module.compatibility_mode_ami]
}

resource "aws_security_group" "compatibility_mode" {
  name_prefix = "${local.cefd_resource_name}-"
  description = "Allow TLS inbound / outbound traffic"
  vpc_id      = data.aws_vpc.selected.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
    self        = false
  }
  tags = local.TAGS
}

data "aws_region" "current" {}

resource "terraform_data" "terminate_cefd_runners" {

  input = data.aws_region.current.name

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      INSTANCE_IDS=$(aws ec2 describe-instances \
        --filters "Name=tag:warmpool,Values=true" \
                  "Name=instance-state-name,Values=running,stopped,pending,stopping" \
        --query "Reservations[].Instances[].InstanceId" \
        --region ${self.output} \
        --output text)

      if [ -n "$INSTANCE_IDS" ]; then
        aws ec2 terminate-instances --instance-ids $INSTANCE_IDS --region ${self.output}
      fi
    EOT
  }
  depends_on = [aws_autoscaling_group.compatibility_mode]
}