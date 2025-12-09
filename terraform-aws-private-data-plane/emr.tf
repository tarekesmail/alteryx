module "emr" {
  count  = var.ENABLE_EMR_SERVERLESS ? 1 : 0
  source = "./modules/aws-emr-serverless"
  ##-- TODO rename account_id variable on the module to resource_name --##
  account_id = local.resource_name
  region     = local.region
  allowed_role_arns = coalescelist(
    distinct(compact(var.AWS_DATAPLANE_EMR_SERVERLESS_TRUSTED_AWS_ACCOUNT_IDS)),
  [local.account_id])
  vpc_id                                            = var.AWS_DATAPLANE_VPC_ID
  subnet_tag                                        = tomap({ key = "AACSubnet", value = "option" })
  tags                                              = local.common_tags
  emr_serverless_job_launch_role_name               = "${local.resource_name}-emr-serverless-job-launch"
  emr_serverless_emr_serverless_spark_exe_role_name = "${local.resource_name}-emr-serverless-spark-execution"
}
