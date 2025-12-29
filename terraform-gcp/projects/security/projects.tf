# Security Project and Folder Management
#
# This file manages the Security folder and project resources that were created manually
# and are now being imported into Terraform for infrastructure-as-code management.

# ============================================
# Security Folder
# ============================================

resource "google_folder" "security" {
  display_name = "Security"
  parent       = "folders/${var.tf_dev_folder_id}"  # tf-dev parent folder
}

# ============================================
# Security ACM Project
# ============================================

resource "google_project" "security" {
  project_id      = var.security_project_id
  name            = var.security_project_id
  folder_id       = google_folder.security.name
  billing_account = var.billing_account
}

# ============================================
# Enable Required APIs
# ============================================

resource "google_project_service" "security_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "accesscontextmanager.googleapis.com",
    "securitycenter.googleapis.com"
  ])
  
  project = google_project.security.project_id
  service = each.key
  
  disable_on_destroy = false
  
  depends_on = [google_project.security]
}
