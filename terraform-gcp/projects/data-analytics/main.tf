# Data Analytics Project Configuration
#
# This configuration manages Looker Studio workspaces for Development and Production
# Projects should be created manually and their IDs provided via variables

# ============================================
# LOOKER STUDIO DEVELOPMENT
# ============================================
#
# Looker Studio (formerly Google Data Studio) provides:
# - Interactive dashboards and reports
# - Data visualization
# - Self-service analytics
# - Integration with BigQuery

# Development Looker Instance Configuration
# Note: Looker Studio is primarily a web-based service
# Infrastructure components typically include:
# - Service accounts for data access
# - BigQuery connection permissions
# - GCS buckets for caching and exports

# Service Account for Looker Development
# resource "google_service_account" "looker_dev" {
#   project      = var.looker_dev_project_id
#   account_id   = "looker-dev-sa"
#   display_name = "Looker Development Service Account"
#   description  = "Service account for Looker Studio development environment"
# }

# Grant BigQuery access to Looker Dev SA
# resource "google_project_iam_member" "looker_dev_bigquery" {
#   project = var.data_core_dev_project_id
#   role    = "roles/bigquery.dataViewer"
#   member  = "serviceAccount:${google_service_account.looker_dev.email}"
# }

# GCS Bucket for Looker Dev cache/exports
# resource "google_storage_bucket" "looker_dev_cache" {
#   project       = var.looker_dev_project_id
#   name          = "${var.company_name}-looker-dev-cache"
#   location      = var.region
#   storage_class = "STANDARD"
#   
#   uniform_bucket_level_access = true
#   
#   lifecycle_rule {
#     action {
#       type = "Delete"
#     }
#     condition {
#       age = 7  # Delete cache files after 7 days
#     }
#   }
# }

# ============================================
# LOOKER STUDIO PRODUCTION
# ============================================

# Service Account for Looker Production
# resource "google_service_account" "looker_prod" {
#   project      = var.looker_prod_project_id
#   account_id   = "looker-prod-sa"
#   display_name = "Looker Production Service Account"
#   description  = "Service account for Looker Studio production environment"
# }

# Grant BigQuery access to Looker Prod SA (read-only gold tier)
# resource "google_bigquery_dataset_iam_member" "looker_prod_gold_access" {
#   project    = var.data_core_prod_project_id
#   dataset_id = "gold"
#   role       = "roles/bigquery.dataViewer"
#   member     = "serviceAccount:${google_service_account.looker_prod.email}"
# }

# GCS Bucket for Looker Prod cache/exports
# resource "google_storage_bucket" "looker_prod_cache" {
#   project       = var.looker_prod_project_id
#   name          = "${var.company_name}-looker-prod-cache"
#   location      = var.region
#   storage_class = "STANDARD"
#   
#   uniform_bucket_level_access = true
#   versioning {
#     enabled = true
#   }
#   
#   lifecycle_rule {
#     action {
#       type = "Delete"
#     }
#     condition {
#       age = 30  # Keep production cache for 30 days
#     }
#   }
# }

# Example: Scheduled Query for Looker dashboards
# resource "google_bigquery_data_transfer_config" "looker_metrics" {
#   project                = var.looker_prod_project_id
#   display_name           = "Looker Dashboard Metrics"
#   location               = var.region
#   data_source_id         = "scheduled_query"
#   schedule               = "every day 06:00"
#   destination_dataset_id = "looker_metrics"
#   
#   params = {
#     query = <<-SQL
#       SELECT
#         DATE(timestamp) as date,
#         user_id,
#         COUNT(*) as page_views
#       FROM `${var.data_core_prod_project_id}.gold.user_events`
#       WHERE DATE(timestamp) = CURRENT_DATE() - 1
#       GROUP BY date, user_id
#     SQL
#     
#     destination_table_name_template = "daily_metrics_{run_date}"
#     write_disposition               = "WRITE_TRUNCATE"
#   }
# }

# Placeholder outputs for future expansion
output "looker_dev_project_id" {
  description = "Looker development project ID"
  value       = var.looker_dev_project_id
}

output "looker_prod_project_id" {
  description = "Looker production project ID"
  value       = var.looker_prod_project_id
}
