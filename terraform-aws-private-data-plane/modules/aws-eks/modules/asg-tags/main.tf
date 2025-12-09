locals {
  taint_effects = {
    NO_SCHEDULE        = "NoSchedule"
    NO_EXECUTE         = "NoExecute"
    PREFER_NO_SCHEDULE = "PreferNoSchedule"
  }

  cluster_autoscaler_label_tags = merge([
    for name, group in var.eks_managed_node_groups : {
      for label_name, label_value in coalesce(group.node_group_labels, {}) : "${name}|label|${label_name}" => {
        autoscaling_group = group.node_group_autoscaling_group_names[0],
        asgKey            = "k8s.io/cluster-autoscaler/node-template/label/${label_name}",
        asgValue          = label_value,
      }
    }
  ]...)

  cluster_autoscaler_taint_tags = merge([
    for name, group in var.eks_managed_node_groups : {
      for taint in coalesce(group.node_group_taints, []) : "${name}|taint|${taint.key}" => {
        autoscaling_group = group.node_group_autoscaling_group_names[0],
        asgKey            = "k8s.io/cluster-autoscaler/node-template/taint/${taint.key}"
        asgValue          = "${taint.value}:${local.taint_effects[taint.effect]}"
      }
    }
  ]...)

  cluster_autoscaler_name_tags = merge([
    for name, group in var.eks_managed_node_groups : {
      "${name}|Name" = {
        autoscaling_group = group.node_group_autoscaling_group_names[0],
        asgKey            = "Name",
        asgValue          = "${name}-worker-node",
      }
    }
  ]...)

  cluster_autoscaler_asg_tags = merge(local.cluster_autoscaler_label_tags, local.cluster_autoscaler_taint_tags, local.cluster_autoscaler_name_tags)
}

resource "aws_autoscaling_group_tag" "cluster_autoscaler_label_tags" {
  for_each = local.cluster_autoscaler_asg_tags

  autoscaling_group_name = each.value.autoscaling_group

  tag {
    key   = each.value.asgKey
    value = each.value.asgValue

    propagate_at_launch = true
  }
}