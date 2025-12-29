# Monitoring Project and Folder Management
#
# This file manages the Monitoring folder and project resources that were created manually
# and are now being imported into Terraform for infrastructure-as-code management.

# ============================================
# Monitoring Folder
# ============================================

resource "google_folder" "monitoring" {
  display_name = "Monitoring"
  parent       = "folders/${var.tf_dev_folder_id}"  # tf-dev parent folder
}

# ============================================
# Central Monitoring Project
# ============================================

resource "google_project" "monitoring" {
  project_id      = var.monitoring_project_id
  name            = var.monitoring_project_id
  folder_id       = google_folder.monitoring.name
  billing_account = var.billing_account
}

# ============================================
# Enable Required APIs
# ============================================

resource "google_project_service" "monitoring_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudtrace.googleapis.com",
    "cloudprofiler.googleapis.com"
  ])
  
  project = google_project.monitoring.project_id
  service = each.key
  
  disable_on_destroy = false
  
  depends_on = [google_project.monitoring]
}
