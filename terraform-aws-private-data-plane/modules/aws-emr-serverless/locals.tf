
locals {
  SERVERLESS_BUCKET_NAME    = coalesce(var.bucket_id, format("%s-emr-logs", var.account_id))
  SERVERLESS_ROLE_APPS_JOBS = var.emr_serverless_job_launch_role_name
  SERVERLESS_ROLE_SPARK_EXE = var.emr_serverless_emr_serverless_spark_exe_role_name
}