# GCP Folder and Project Resources
# These folders and projects are created and managed by Terraform
# Structure: tf-dev (1056367965450) > Data Core (384531291110) > Archive/Development/Production sub-folders > Projects

# ============================================
# Data Core Folder
# ============================================

resource "google_folder" "data_core" {
  display_name = "Data Core"
  parent       = "folders/${var.tf_dev_folder_id}"  # tf-dev parent folder
}

# ============================================
# Archive Sub-Folder
# ============================================

resource "google_folder" "archive" {
  display_name = "Archive"
  parent       = google_folder.data_core.name  # Reference the created Data Core folder
}

# Archive Project
resource "google_project" "archive" {
  name            = "Archive"
  project_id      = var.archive_project_id
  folder_id       = google_folder.archive.name  # Reference the created Archive folder
  billing_account = var.billing_account
  
  labels = {
    environment = "archive"
    managed_by  = "terraform"
    team        = "data-engineering"
  }
}

# Enable APIs for Archive project
resource "google_project_service" "archive_apis" {
  for_each = toset([
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
  ])

  project            = google_project.archive.project_id
  service            = each.value
  disable_on_destroy = false
}

# ============================================
# Development Sub-Folder
# ============================================

resource "google_folder" "development" {
  display_name = "Development"
  parent       = google_folder.data_core.name  # Reference the created Data Core folder
}

# Development Project
resource "google_project" "development" {
  name            = "Data Core Development"
  project_id      = var.development_project_id
  folder_id       = google_folder.development.name  # Reference the created Development folder
  billing_account = var.billing_account
  
  labels = {
    environment = "development"
    managed_by  = "terraform"
    team        = "data-engineering"
  }
}

# Enable APIs for Development project
resource "google_project_service" "development_apis" {
  for_each = toset([
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
  ])

  project            = google_project.development.project_id
  service            = each.value
  disable_on_destroy = false
}

# ============================================
# Production Sub-Folder
# ============================================

resource "google_folder" "production" {
  display_name = "Production"
  parent       = google_folder.data_core.name  # Reference the created Data Core folder
}

# Production Project
resource "google_project" "production" {
  name            = "Data Core Production"
  project_id      = var.production_project_id
  folder_id       = google_folder.production.name  # Reference the created Production folder
  billing_account = var.billing_account
  
  labels = {
    environment = "production"
    managed_by  = "terraform"
    team        = "data-engineering"
  }
}

# Enable APIs for Production project
resource "google_project_service" "production_apis" {
  for_each = toset([
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "cloudkms.googleapis.com",
  ])

  project            = google_project.production.project_id
  service            = each.value
  disable_on_destroy = false
}
