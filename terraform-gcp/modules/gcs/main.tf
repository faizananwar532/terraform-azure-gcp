/**
 * GCS Bucket Module
 * Creates Google Cloud Storage buckets with optional hierarchical namespace
 */

resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  project       = var.project_id
  location      = var.location
  force_destroy = var.force_destroy
  
  uniform_bucket_level_access = true
  
  # Note: Hierarchical namespace is a newer feature and may require specific configurations
  # It's enabled by default for new buckets in certain regions
  # If you need this feature, you may need to use google-beta provider
  
  # Versioning
  versioning {
    enabled = var.enable_versioning
  }
  
  # Lifecycle rules
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                   = lookup(lifecycle_rule.value.condition, "age", null)
        created_before        = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state            = lookup(lifecycle_rule.value.condition, "with_state", null)
        matches_storage_class = lookup(lifecycle_rule.value.condition, "matches_storage_class", null)
        num_newer_versions    = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
      }
    }
  }
  
  # Encryption
  dynamic "encryption" {
    for_each = var.kms_key_name != null ? [1] : []
    content {
      default_kms_key_name = var.kms_key_name
    }
  }
  
  labels = merge(
    var.labels,
    {
      managed_by = "terraform"
    }
  )
}

# IAM bindings for the bucket
resource "google_storage_bucket_iam_member" "members" {
  for_each = var.iam_members
  
  bucket = google_storage_bucket.bucket.name
  role   = each.value.role
  member = each.value.member
}
