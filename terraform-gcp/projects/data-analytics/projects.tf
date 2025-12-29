# Data Analytics (Looker) Projects and Folder Management
#
# This file manages the Data Analytics folder and project resources that were created manually
# and are now being imported into Terraform for infrastructure-as-code management.

# ============================================
# Data Analytics Folder (already exists - import only)
# ============================================

resource "google_folder" "data_analytics" {
  display_name = "Data Analytics"
  parent       = "folders/${var.tf_dev_folder_id}"  # tf-dev parent folder
}

# ============================================
# Looker Subfolder (already exists - import only)
# Reference: This folder exists under Data Analytics folder
# ============================================

resource "google_folder" "looker" {
  display_name = "Looker"
  parent       = google_folder.data_analytics.name  # Reference the created Data Analytics folder
}

# ============================================
# Looker Development Project
# ============================================

resource "google_project" "looker_development" {
  project_id      = var.looker_dev_project_id
  name            = var.looker_dev_project_id
  folder_id       = google_folder.looker.name  # Reference the created Looker folder
  billing_account = var.billing_account
}

# ============================================
# Looker Production Project
# ============================================

resource "google_project" "looker_production" {
  project_id      = var.looker_prod_project_id
  name            = var.looker_prod_project_id
  folder_id       = google_folder.looker.name  # Reference the created Looker folder
  billing_account = var.billing_account
}

# ============================================
# Enable Required APIs - Development
# ============================================

resource "google_project_service" "looker_dev_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "bigquery.googleapis.com",
    "looker.googleapis.com",
    "compute.googleapis.com"
  ])
  
  project = google_project.looker_development.project_id
  service = each.key
  
  disable_on_destroy = false
  
  depends_on = [google_project.looker_development]
}

# ============================================
# Enable Required APIs - Production
# ============================================

resource "google_project_service" "looker_prod_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "bigquery.googleapis.com",
    "looker.googleapis.com",
    "compute.googleapis.com"
  ])
  
  project = google_project.looker_production.project_id
  service = each.key
  
  disable_on_destroy = false
  
  depends_on = [google_project.looker_production]
}
