
resource "aws_secretsmanager_secret" "sm" {
  for_each                = nonsensitive(var.secrets)
  name                    = lookup(each.value, "name_prefix", null) == null ? each.key : null
  name_prefix             = lookup(each.value, "name_prefix", null) != null ? lookup(each.value, "name_prefix") : null
  description             = lookup(each.value, "description", null)
  kms_key_id              = lookup(each.value, "kms_key_id", null)
  policy                  = lookup(each.value, "policy", null)
  recovery_window_in_days = lookup(each.value, "recovery_window_in_days", var.recovery_window_in_days)
  tags                    = merge(var.tags, try(each.value["tags"], {}))
  dynamic "replica" {
    for_each = var.replica_regions
    content {
      region     = replica.key
      kms_key_id = replica.value
    }
  }
}

resource "aws_secretsmanager_secret_version" "sm-sv" {
  for_each      = nonsensitive({ for k, v in var.secrets : k => v if !var.unmanaged })
  secret_id     = each.key
  secret_string = try(base64decode(each.value.secret_key_value), null) == null ? try(jsonencode(tomap(each.value.secret_key_value)), each.value.secret_key_value) : null
  secret_binary = try(base64decode(each.value.secret_key_value), null) != null ? try(jsonencode(tomap(each.value.secret_key_value)), each.value.secret_key_value) : null
  depends_on    = [aws_secretsmanager_secret.sm]
}


# Rotate secrets
resource "aws_secretsmanager_secret" "rsm" {
  for_each                = var.rotate_secrets
  name                    = lookup(each.value, "name_prefix", null) == null ? each.key : null
  name_prefix             = lookup(each.value, "name_prefix", null) != null ? lookup(each.value, "name_prefix") : null
  description             = lookup(each.value, "description")
  kms_key_id              = lookup(each.value, "kms_key_id", null)
  policy                  = lookup(each.value, "policy", null)
  recovery_window_in_days = lookup(each.value, "recovery_window_in_days", var.recovery_window_in_days)
  tags                    = merge(var.tags, lookup(each.value, "tags", null))
}

resource "aws_secretsmanager_secret_version" "rsm-sv" {
  for_each      = { for k, v in var.rotate_secrets : k => v if !var.unmanaged }
  secret_id     = each.key
  secret_string = try(base64decode(each.value.secret_key_value), null) == null ? try(jsonencode(tomap(each.value.secret_key_value)), each.value.secret_key_value) : null
  secret_binary = try(base64decode(each.value.secret_key_value), null) != null ? try(jsonencode(tomap(each.value.secret_key_value)), each.value.secret_key_value) : null
  depends_on    = [aws_secretsmanager_secret.rsm]
}
