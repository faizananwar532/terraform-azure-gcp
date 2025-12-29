/**
 * BigQuery Module
 * 
 * This module creates BigQuery datasets with configurable settings including:
 * - Dataset creation with location and description
 * - Access controls (IAM bindings)
 * - Default table expiration
 * - Encryption settings
 * - Labels for organization
 */

resource "google_bigquery_dataset" "dataset" {
  project                     = var.project_id
  dataset_id                  = var.dataset_id
  friendly_name               = var.friendly_name
  description                 = var.description
  location                    = var.location
  default_table_expiration_ms = var.default_table_expiration_ms
  delete_contents_on_destroy  = var.delete_contents_on_destroy

  labels = merge(
    var.labels,
    {
      managed_by = "terraform"
      created_at = formatdate("YYYY-MM-DD", timestamp())
    }
  )

  dynamic "access" {
    for_each = var.access_roles
    content {
      role          = access.value.role
      user_by_email = lookup(access.value, "user_by_email", null)
      group_by_email = lookup(access.value, "group_by_email", null)
      special_group = lookup(access.value, "special_group", null)
    }
  }

  dynamic "default_encryption_configuration" {
    for_each = var.kms_key_name != null ? [1] : []
    content {
      kms_key_name = var.kms_key_name
    }
  }
}

# BigQuery Tables (optional)
resource "google_bigquery_table" "tables" {
  for_each = var.tables

  project    = var.project_id
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = each.key

  description = lookup(each.value, "description", null)
  
  dynamic "time_partitioning" {
    for_each = lookup(each.value, "time_partitioning", null) != null ? [each.value.time_partitioning] : []
    content {
      type                     = time_partitioning.value.type
      expiration_ms            = lookup(time_partitioning.value, "expiration_ms", null)
      field                    = lookup(time_partitioning.value, "field", null)
      require_partition_filter = lookup(time_partitioning.value, "require_partition_filter", false)
    }
  }

  clustering = lookup(each.value, "clustering", null) != null ? each.value.clustering.fields : null

  schema = lookup(each.value, "schema", null)

  labels = merge(
    var.labels,
    lookup(each.value, "labels", {}),
    {
      managed_by = "terraform"
    }
  )

  depends_on = [google_bigquery_dataset.dataset]
}

# IAM bindings for the dataset
resource "google_bigquery_dataset_iam_member" "members" {
  for_each = var.dataset_iam_members

  project    = var.project_id
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  role       = each.value.role
  member     = each.value.member

  depends_on = [google_bigquery_dataset.dataset]
}
