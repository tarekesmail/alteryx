
resource "google_secret_manager_secret" "secrets" {
  for_each = var.secret_list

  secret_id = each.key
  project   = var.management_project

  labels = merge(
    var.common_labels,
    {
      "ayx" = each.value.tag
    },
  )

  replication {
    user_managed {
      replicas {
        location = var.management_region
      }
    }
  }
}

// lifecycle_ignore defaults to 'false' which will run this block
resource "google_secret_manager_secret_version" "secrets-version" {
  for_each = var.lifecycle_ignore ? {} : var.secret_list

  secret      = google_secret_manager_secret.secrets[each.key].id
  secret_data = each.value.value

}

// when lifecycle_ignore is 'true', this block will run
resource "google_secret_manager_secret_version" "secrets-version-lifecycle" {
  for_each = var.lifecycle_ignore ? var.secret_list : {}

  secret      = google_secret_manager_secret.secrets[each.key].id
  secret_data = each.value.value

  lifecycle {
    ignore_changes = [secret_data]
  }
}
