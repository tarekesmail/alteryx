output "serverless" {
  description = "EMR Serverless configuration including resource bucket, subnets, and IAM roles"
  value = {
    resourceBucket    = "arn:aws:s3:::${local.SERVERLESS_BUCKET_NAME}"
    subnetIds         = data.aws_subnets.emr_serverless.ids
    region            = var.region
    jobLaunchArn      = aws_iam_role.job_launch.arn
    jobRuntimeRoleArn = aws_iam_role.job_runtime.arn
    externalId        = var.external_id
    securityGroups    = tolist([aws_security_group.emr_serverless.id])
  }
}

output "iam_policies" {
  description = "IAM policy documents for EMR Serverless job launch and runtime roles"
  value = {
    job_launch  = data.aws_iam_policy_document.job_launch
    job_runtime = data.aws_iam_policy_document.job_runtime
  }
}

output "EMR_SERVERLESS" {
  description = "EMR Serverless: Automation of control plane configuration for Private data plane"
  value = {
    "aws.emrServerless.resourceBucket"          = local.SERVERLESS_BUCKET_NAME
    "aws.emrServerless.config.subnetIds"        = data.aws_subnets.emr_serverless.ids
    "aws.emrServerless.config.securityGroupIds" = tolist([aws_security_group.emr_serverless.id])
    "aws.emrServerless.region"                  = var.region
    "aws.emrServerless.jobRuntimeRoleArn"       = aws_iam_role.job_runtime.arn
  }
}
