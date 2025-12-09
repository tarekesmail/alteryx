module "ebs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  # This role name referenced statically in the locals due to a cyclical dependency problem
  role_name             = "${var.cluster_name}-ebs-csi-controller"
  attach_ebs_csi_policy = true
  policy_name_prefix    = var.cluster_name

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}
