moved {
  from = module.eks_blue
  to   = module.eks_blue[0]
}

moved {
  from = aws_iam_role.role_trusted_user
  to   = aws_iam_role.role_trusted_user[0]
}

moved {
  from = aws_iam_policy.policy_assume_role
  to   = aws_iam_policy.policy_assume_role[0]
}

moved {
  from = data.aws_iam_policy_document.policy_assume_role
  to   = data.aws_iam_policy_document.policy_assume_role[0]
}

moved {
  from = google_service_account.pdp_gar_sa
  to   = google_service_account.pdp_gar_sa[0]
}

moved {
  from = google_service_account_key.pdp_gar_sa_key
  to   = google_service_account_key.pdp_gar_sa_key[0]
}

moved {
  from = google_project_iam_member.pdp_gar_iam
  to   = google_project_iam_member.pdp_gar_iam[0]
}

moved {
  from = aws_security_group.allow_starayx_to_eks
  to   = aws_security_group.allow_starayx_to_eks[0]
}

moved {
  from = module.starayx
  to   = module.starayx[0]
}

moved {
  from = module.teleport
  to   = module.teleport[0]
}

moved {
  from = module.data_plane_private_helm
  to   = module.data_plane_private_helm[0]
}

moved {
  from = module.teleport[0].aws_security_group.teleport_agent
  to   = aws_security_group.teleport_agent[0]
}

# kafka confluent
moved {
  from = confluent_service_account.dp_aidin_sa
  to   = confluent_service_account.confluent_sa
}

moved {
  from = confluent_api_key.dp_aidin_sa
  to   = confluent_api_key.confluent_api_key
}