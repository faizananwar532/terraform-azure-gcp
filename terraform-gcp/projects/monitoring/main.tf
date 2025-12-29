# Monitoring Project Configuration
#
# This configuration manages the Central Monitoring project for logging and monitoring
# Projects should be created manually and their IDs provided via variables

# ============================================
# CENTRALIZED LOGGING & MONITORING
# ============================================
#
# This project serves as a centralized hub for:
# - Cloud Logging (log aggregation from all projects)
# - Cloud Monitoring (metrics and alerting)
# - Log Analytics
# - Custom dashboards
# - Alert policies
# - Uptime checks

# Example: Log Sink to aggregate logs from all projects
# resource "google_logging_project_sink" "data_core_logs" {
#   name        = "data-core-logs-sink"
#   project     = var.data_core_project_id
#   destination = "logging.googleapis.com/projects/${var.monitoring_project_id}/locations/global/buckets/centralized-logs"
#   
#   filter = <<-EOT
#     resource.type="bigquery_resource" OR
#     resource.type="gcs_bucket"
#   EOT
#   
#   unique_writer_identity = true
# }

# Example: Log Bucket for centralized storage
# resource "google_logging_project_bucket_config" "centralized_logs" {
#   project        = var.monitoring_project_id
#   location       = "global"
#   retention_days = 30
#   bucket_id      = "centralized-logs"
#   description    = "Centralized log bucket for all projects"
# }

# Example: Monitoring Dashboard
# resource "google_monitoring_dashboard" "main" {
#   project        = var.monitoring_project_id
#   dashboard_json = jsonencode({
#     displayName = "Infrastructure Overview"
#     dashboardFilters = []
#     gridLayout = {
#       widgets = [
#         {
#           title = "BigQuery Job Statistics"
#           xyChart = {
#             dataSets = [{
#               timeSeriesQuery = {
#                 timeSeriesFilter = {
#                   filter = "resource.type=\"bigquery_project\""
#                 }
#               }
#             }]
#           }
#         }
#       ]
#     }
#   })
# }

# Example: Alert Policy for BigQuery slot utilization
# resource "google_monitoring_alert_policy" "bigquery_slots" {
#   project      = var.monitoring_project_id
#   display_name = "BigQuery Slot Utilization"
#   combiner     = "OR"
#   
#   conditions {
#     display_name = "High slot utilization"
#     condition_threshold {
#       filter          = "resource.type=\"bigquery_project\""
#       duration        = "300s"
#       comparison      = "COMPARISON_GT"
#       threshold_value = 0.8
#     }
#   }
#   
#   notification_channels = var.notification_channels
# }

# Example: Uptime Check for critical services
# resource "google_monitoring_uptime_check_config" "looker_uptime" {
#   display_name = "Looker Production Uptime"
#   project      = var.monitoring_project_id
#   timeout      = "10s"
#   period       = "60s"
#   
#   http_check {
#     path         = "/health"
#     port         = 443
#     use_ssl      = true
#     validate_ssl = true
#   }
#   
#   monitored_resource {
#     type = "uptime_url"
#     labels = {
#       project_id = var.data_analytics_prod_project_id
#       host       = "looker.example.com"
#     }
#   }
# }

# Placeholder outputs for future expansion
output "monitoring_project_id" {
  description = "Central monitoring project ID"
  value       = var.monitoring_project_id
}
