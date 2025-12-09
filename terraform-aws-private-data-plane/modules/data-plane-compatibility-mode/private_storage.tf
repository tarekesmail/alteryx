resource "aws_s3_bucket" "custom_drivers_storage" {
  count = var.ENABLE_CLOUD_EXECUTION_CUSTOMDRIVER ? 1 : 0

  bucket = "alteryx-customizations-${var.resource_name}"
  acl    = "private"

  force_destroy = true
  tags = {
    Name = "alteryx-customizations-${var.resource_name}"
  }
}