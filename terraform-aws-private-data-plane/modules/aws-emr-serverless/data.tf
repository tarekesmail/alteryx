
data "aws_subnets" "emr_serverless" {
  filter {
    name   = "tag:${var.subnet_tag.key}"
    values = ["${var.subnet_tag.value}"]
  }
}