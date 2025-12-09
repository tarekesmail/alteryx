
data "aws_subnets" "selected" {
  filter {
    name   = "tag:${var.subnet_tag.key}"
    values = [var.subnet_tag.value]
  }
}

data "shell_script" "user_data_agent" {
  lifecycle_commands {
    read = file("${path.module}/scripts/read-linux.sh")
  }

  environment = {
    PATHROOT              = "${path.module}"
    TELEPORT_EKS_ENABLED  = var.teleport_eks_enabled
    TELEPORT_EKS_HOSTNAME = var.teleport_eks_host
    TELEPORT_APP_NAME     = "pdp-aws-k8sapi-${var.eks_cluster_name}"
    TELEPORT_CLUSTER      = var.teleport_cluster
    TELEPORT_PROXY_URI    = var.teleport_proxy_uri
    TELEPORT_TAGKEY       = "Teleport_Windows_Target"
    TELEPORT_TAGVAL       = "true"
    TELEPORT_LABELKEY     = "awsAccountId"
    TELEPORT_LABELVAL     = var.account_name
    TELEPORT_LABELS = base64encode(jsonencode(
      {
        aac_workspace_id             = var.SEGMENTID
        cloud_region                 = var.region
        cloud_id                     = var.account_name
        cloud                        = "AWS"
        terraform_cloud_workspace_id = var.TF_CLOUD_WORKSPACE
        control_plane_name           = var.control_plane_name
        domain_name                  = var.CONTROL_PLANE_DOMAIN
      }
    ))
    TELEPORT_AWS_REGION = var.region
    TELEPORT_TOKEN      = var.teleport_windows_token
  }
}

resource "aws_launch_template" "bootstrap" {
  name_prefix = "${var.resource_name}-teleport"
  image_id    = var.teleport_agent_base_ami


  instance_type = "t3.medium"

  #  network_interfaces {
  #    associate_public_ip_address = true
  #    security_groups = [var.eks_security_group_id]
  #  }

  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size           = 10
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "teleport-agent"
    }
  }

  user_data = base64encode(templatefile("${path.module}/teleport/expand.sh.tpl",
    {
      userdata = data.shell_script.user_data_agent.output["zipcontent"]
    }
    )
  )

  vpc_security_group_ids = [var.eks_security_group_id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.instance_profile.arn
  }
}

# resource "aws_security_group" "teleport_agent" {
#   name        = "teleport_agent"
#   description = "Allow TLS inbound traffic to EKS Cluster"
#   vpc_id      = var.vpc_id
# }

resource "aws_vpc_security_group_egress_rule" "teleport_agent" {
  ip_protocol       = -1
  security_group_id = var.eks_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "teleport_agent" {
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 3389
  security_group_id            = var.eks_security_group_id
  referenced_security_group_id = var.eks_security_group_id
}

resource "aws_autoscaling_group" "bootstrap" {
  name              = "${var.resource_name}-teleport"
  min_size          = var.teleport_min_size
  max_size          = 2
  health_check_type = "EC2"

  launch_template {
    id      = aws_launch_template.bootstrap.id
    version = aws_launch_template.bootstrap.latest_version
  }

  vpc_zone_identifier = data.aws_subnets.selected.ids

  lifecycle {
    replace_triggered_by = [
      aws_launch_template.bootstrap.latest_version
    ]
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.resource_name}-teleport_agent_profile"
  role = aws_iam_role.iam_role.name
}

resource "aws_iam_role" "iam_role" {
  name                  = "${var.resource_name}-teleport_agent_role"
  force_detach_policies = true

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
	{
	    "Action": "sts:AssumeRole",
	    "Principal": {
	       "Service": [
		  "ec2.amazonaws.com"
	      ]
	    },
	    "Effect": "Allow",
	    "Sid": ""
	}
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.ec2_iam_policy.arn
}


resource "aws_iam_policy" "ec2_iam_policy" {
  name        = "${var.resource_name}-teleport_agent_policy"
  description = "Teleport Agent Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeTags",
        "ec2:DescribeInstances"
      ],
      "Resource": "*"
    }
  ]
}
	EOF
}
