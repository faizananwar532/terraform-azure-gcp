# Security Project Configuration
#
# This configuration manages the Security ACM (Access Context Manager) project

# ============================================
# ACCESS CONTEXT MANAGER (ACM)
# ============================================
# 
# Access Context Manager helps you define fine-grained, attribute-based
# access control for projects and resources in Google Cloud.
#
# Common use cases:
# - Define access levels based on IP addresses, device type, or user identity
# - Create service perimeters to prevent data exfiltration
# - Control access to GCP services based on context
#
# Configuration can include:
# - Access Policies
# - Access Levels (IP-based, device-based, etc.)
# - Service Perimeters
# - VPC Service Controls

# Note: ACM requires organization-level permissions
# Example configuration structure (to be customized):

# resource "google_access_context_manager_access_policy" "main" {
#   parent = var.org_id
#   title  = "Security ACM Policy"
# }
# 
# resource "google_access_context_manager_access_level" "office_ip" {
#   parent = google_access_context_manager_access_policy.main.name
#   name   = "office_ip_access"
#   title  = "Office IP Access Level"
# 
#   basic {
#     conditions {
#       ip_subnetworks = var.allowed_ip_ranges
#     }
#   }
# }
#
# resource "google_access_context_manager_service_perimeter" "data_core" {
#   parent = google_access_context_manager_access_policy.main.name
#   name   = "data_core_perimeter"
#   title  = "Data Core Service Perimeter"
#   
#   status {
#     restricted_services = [
#       "bigquery.googleapis.com",
#       "storage.googleapis.com"
#     ]
#     resources = [
#       "projects/${var.data_core_dev_project_number}",
#       "projects/${var.data_core_prod_project_number}"
#     ]
#   }
# }

# Placeholder outputs for future expansion
output "security_project_id" {
  description = "Security ACM project ID"
  value       = var.security_project_id
}
