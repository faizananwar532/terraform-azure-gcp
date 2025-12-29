# Networking Projects Configuration
# 
# This file manages the folder structure and projects for the Networking module

# ============================================
# Networking Sub-Folder
# ============================================

resource "google_folder" "networking" {
  display_name = "Networking"
  parent       = "folders/${var.tf_dev_folder_id}"  # tf-dev parent folder
}

# ============================================
# Development Networking Project
# ============================================

resource "google_project" "development" {
  name            = "Networking Development"
  project_id      = var.networking_dev_project_id
  folder_id       = google_folder.networking.name
  billing_account = var.billing_account
  
  labels = {
    environment = "development"
    managed_by  = "terraform"
    team        = "data-engineering"
  }
}

# Enable APIs for Development project
resource "google_project_service" "networking_dev_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
  ])

  project            = google_project.development.project_id
  service            = each.value
  disable_on_destroy = false
}

# ============================================
# Production Networking Project
# ============================================

resource "google_project" "production" {
  name            = "Networking Production"
  project_id      = var.networking_prod_project_id
  folder_id       = google_folder.networking.name
  billing_account = var.billing_account
  
  labels = {
    environment = "production"
    managed_by  = "terraform"
    team        = "data-engineering"
  }
}

# Enable APIs for Production project
resource "google_project_service" "networking_prod_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
  ])

  project            = google_project.production.project_id
  service            = each.value
  disable_on_destroy = false
}
