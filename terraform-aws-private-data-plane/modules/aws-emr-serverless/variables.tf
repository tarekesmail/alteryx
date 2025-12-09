
variable "region" {
  description = "data-plane region"
  type        = string
}

variable "account_id" {
  description = "data-plane name"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "allowed_role_arns" {
  description = "aws principals allowed"
  type        = list(string)
  default     = []
}

variable "emr_serverless_job_launch_role_name" {
  description = "The default name for emr_serverless job launch iam role"
  type        = string
  default     = "emr-serverless-job-launch"
}

variable "emr_serverless_emr_serverless_spark_exe_role_name" {
  description = "The default name for emr serverless spark execution iam role"
  type        = string
  default     = "emr-serverless-spark-execution"
}

variable "external_id" {
  type    = string
  default = ""
}

variable "security_groups" {
  type    = list(string)
  default = []
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "trifacta_public_buckets_names" {
  type = list(string)
  default = [
    "trifacta-public-datasets",
    "3fac-data-public",
  ]
}

variable "bucket_id" {
  description = "empty by default so and we create bucket in this case (default create s3 bucket for emr logs)"
  type        = string
  default     = ""
}


variable "vpc_id" {
  type    = string
  default = null
}

variable "subnet_tag" {
  type = object({
    key   = string
    value = string
  })
  default = {
    key   = "Name"
    value = "private"
  }

}
