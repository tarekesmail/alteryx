locals {
  EKS_VERSION  = "1.31"
  EKS_NODE_AMI = "1.31.7-20250610"

  eks_config = {
    cluster_version = local.EKS_VERSION
    cluster_addons = {
      # Versions default to latest if not specified
      coredns = {
        addon_version               = "v1.11.4-eksbuild.2" # supported until 1.32
        resolve_conflicts_on_create = "OVERWRITE"
        resolve_conflicts_on_update = "OVERWRITE"
      }
      kube-proxy = {
        addon_version               = "v1.30.11-eksbuild.5" # supported until 1.32
        resolve_conflicts_on_create = "OVERWRITE"
        resolve_conflicts_on_update = "OVERWRITE"
      }
      vpc-cni = {
        addon_version               = "v1.19.5-eksbuild.1" # supported until 1.32
        resolve_conflicts_on_create = "OVERWRITE"
        resolve_conflicts_on_update = "OVERWRITE"
        preserve                    = true
      }
      aws-ebs-csi-driver = {
        addon_version               = "v1.43.0-eksbuild.1" # supported until 1.32
        resolve_conflicts_on_create = "OVERWRITE"
        resolve_conflicts_on_update = "OVERWRITE"
        # We cannot use a dynamic reference here otherwise there is a cyclical depdency
        service_account_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.pdp_eks_name}-ebs-csi-controller"
      }
    }
    cluster_endpoint_public_access_cidrs = local.eks_cluster_endpoint_public_access_cidrs
  }

  key_job_type       = "jobType"
  effect_no_schedule = "NO_SCHEDULE"
  block_device_name  = "/dev/xvda"

  eks_managed_node_group_defaults = {
    create_launch_template     = true # must be set to use default eks template
    use_custom_launch_template = true
    launch_template_name       = ""                 # must be set to use default eks template , so it needs to be empty string
    ami_release_version        = local.EKS_NODE_AMI #  https://github.com/awslabs/amazon-eks-ami/releases
    ami_type                   = "AL2_x86_64"
    disk_size                  = 100
    capacity_type              = "ON_DEMAND"
    taints                     = []
    block_device_mappings = {
      xvda = {
        device_name = local.block_device_name
        ebs = {
          volume_size = 50
          # TODO: figure out if we need to specify any of these values here or for common-job
          # volume_type           = "gp3"
          # iops                  = 3000
          # throughput            = 150
          # encrypted             = true
          # kms_key_id            = aws_kms_key.ebs.arn
          # delete_on_termination = true
        }
      }
    }
  }

  selected_instance_types = lookup(var.region_instance_map, var.AWS_DATAPLANE_REGION, lookup(var.region_instance_map, "default"))
  common_job_max_size     = anytrue([var.CONTROL_PLANE_NAME == "int", var.CONTROL_PLANE_NAME == "preprod"]) ? 100 : 75

  node_group_names = {
    photon      = "photon"
    automl      = "automl"
    convert     = "convert"
    data-system = "data-system"
    file-system = "file-system"
    bullmq      = "bullmq-standard"
  }

  pool_name_suffix = "job-pool"

  # TODO: this can probably all be generated with a for loop as most of it is repetetitive
  eks_managed_node_groups_unfiltered = {
    common-jobs = local.k8s_option_enabled ? {
      name = "common-jobs"
      labels = {
        "pool-name" = "common-job-pool",
        "type"      = "common-job"
      }
      instance_types = local.selected_instance_types.common-job
      min_size       = 1
      desired_size   = 1
      max_size       = local.common_job_max_size
      taints = [
        {
          key    = local.key_job_type
          value  = "common"
          effect = local.effect_no_schedule
        }
      ]
      block_device_mappings = {
        xvda = {
          device_name = local.block_device_name
          ebs = {
            volume_size = 500
          }
        }
      }
    } : null,

    photon = var.ENABLE_DC || var.ENABLE_APPBUILDER ? {
      name = local.node_group_names["photon"]
      labels = {
        "pool-name" = "${local.node_group_names["photon"]}-${local.pool_name_suffix}",
        "type"      = local.node_group_names["photon"]
      }
      instance_types = local.selected_instance_types.photon
      min_size       = 1
      desired_size   = 1
      max_size       = 30
      taints = [
        {
          key    = local.key_job_type
          value  = local.node_group_names["photon"]
          effect = local.effect_no_schedule
        }
      ]
    } : null,

    convert = var.ENABLE_DC || var.ENABLE_APPBUILDER ? {
      name = local.node_group_names["convert"]
      labels = {
        "pool-name" = "${local.node_group_names["convert"]}-${local.pool_name_suffix}",
        "type"      = local.node_group_names["convert"]
      }
      instance_types = local.selected_instance_types.convert
      min_size       = 1
      desired_size   = 1
      max_size       = 30
      taints = [
        {
          key    = local.key_job_type
          value  = "conversion"
          effect = local.effect_no_schedule
        }
      ]
    } : null,

    data-system = var.ENABLE_DC || var.ENABLE_APPBUILDER || var.ENABLE_AUTO_INSIGHTS ? {
      name = local.node_group_names["data-system"]
      labels = {
        "pool-name" = "${local.node_group_names["data-system"]}-${local.pool_name_suffix}",
        "type"      = local.node_group_names["data-system"]
      }
      instance_types = local.selected_instance_types.data-system
      min_size       = 1
      desired_size   = 1
      max_size       = 30
      taints = [
        {
          key    = local.key_job_type
          value  = "dataSystem"
          effect = local.effect_no_schedule
        }
      ]
    } : null,

    file-system = var.ENABLE_DC || var.ENABLE_AUTO_INSIGHTS || var.ENABLE_APPBUILDER ? {
      name = local.node_group_names["file-system"]
      labels = {
        "pool-name" = "${local.node_group_names["file-system"]}-${local.pool_name_suffix}",
        "type"      = local.node_group_names["file-system"]
      }
      instance_types = local.selected_instance_types.file-system
      min_size       = 1
      desired_size   = 1
      max_size       = 30
      taints = [
        {
          key    = local.key_job_type
          value  = "filesystem"
          effect = local.effect_no_schedule
        }
      ]
    } : null,

    automl = var.ENABLE_AML ? {
      name = local.node_group_names["automl"]
      labels = {
        "pool-name" = "${local.node_group_names["automl"]}-${local.pool_name_suffix}",
        "type"      = local.node_group_names["automl"]
      }
      instance_types = local.selected_instance_types.automl
      min_size       = 1
      desired_size   = 1
      max_size       = 10
      taints = [
        {
          key    = local.key_job_type
          value  = local.node_group_names["automl"]
          effect = local.effect_no_schedule
        }
      ]
    } : null,

    bullmq-standard = var.ENABLE_DC || var.ENABLE_APPBUILDER ? {
      # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/compute_resources.md#eks-managed-node-groups
      # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/18.30.1/submodules/eks-managed-node-group?tab=inputs
      name     = local.node_group_names["bullmq"]
      ami_type = "AL2_x86_64"
      labels = {
        "type" = local.node_group_names["bullmq"]
      }
      instance_types = local.selected_instance_types.bullmq-standard
      disk_size      = 50 # default 20
      desired_size   = 0
      max_size       = 100
      min_size       = 0
      capacity_type  = "ON_DEMAND"
      taints = [
        {
          key    = local.key_job_type
          value  = local.node_group_names["bullmq"]
          effect = local.effect_no_schedule
        }
      ]
    } : null
  }

  # Filter out the null values to clean up the eks_managed_node_groups_unfiltered map
  eks_managed_node_groups_filtered = { for k, v in local.eks_managed_node_groups_unfiltered : k => v if v != null }

  exclude_node_groups = [
    for k, name in local.node_group_names : name
  ]

  # do not provision service specific node pools if lowers
  eks_managed_node_groups = {
    for k, v in local.eks_managed_node_groups_filtered : k => v
    if !contains(local.exclude_node_groups, v.name)
  }
}