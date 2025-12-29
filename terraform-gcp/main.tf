# Main Terraform Configuration for GCP tf-dev Organization
#
# All configuration is managed through a single centralized variables file

# ========================================
# Data Core Project
# ========================================

module "data_core" {
  source = "./projects/data-core"

  # Infrastructure
  tf_dev_folder_id = var.tf_dev_folder_id
  billing_account  = var.billing_account
  folder_ids       = var.folder_ids

  # Project IDs
  archive_project_id     = var.data_core.archive_project_id
  development_project_id = var.data_core.development_project_id
  production_project_id  = var.data_core.production_project_id

  # Dataset IDs
  archive_dataset_id     = var.data_core.archive_dataset_id
  development_dataset_id = var.data_core.development_dataset_id
  production_dataset_id  = var.data_core.production_dataset_id

  # Configuration
  location                = coalesce(var.data_core.location, var.region)
  dev_table_expiration_ms = var.data_core.dev_table_expiration_ms

  # Common labels
  common_labels = var.common_labels

  # Access Control
  archive_access_roles     = var.data_core.archive_access_roles
  archive_iam_members      = var.data_core.archive_iam_members
  development_access_roles = var.data_core.development_access_roles
  development_iam_members  = var.data_core.development_iam_members
  production_access_roles  = var.data_core.production_access_roles
  production_iam_members   = var.data_core.production_iam_members

  # Tables
  development_tables = var.data_core.development_tables
  production_tables  = var.data_core.production_tables

  # Encryption
  production_kms_key_name = var.data_core.production_kms_key_name
  
  # GCS Buckets
  development_bucket_name        = coalesce(var.data_core.development_bucket_name, "${var.company_name}-gcs-bucket-dev")
  production_bucket_name         = coalesce(var.data_core.production_bucket_name, "${var.company_name}-gcs-bucket-prod")
  development_bucket_iam_members = var.data_core.development_bucket_iam_members
  production_bucket_iam_members  = var.data_core.production_bucket_iam_members
}

# ========================================
# Security Project
# ========================================

module "security" {
  count  = var.security != null ? 1 : 0
  source = "./projects/security"

  # Infrastructure
  tf_dev_folder_id = var.tf_dev_folder_id
  billing_account  = var.billing_account
  folder_ids       = var.folder_ids

  security_project_id = var.security.project_id
  common_labels       = var.common_labels
}

# ========================================
# Networking Project
# ========================================

module "networking" {
  count  = var.networking != null ? 1 : 0
  source = "./projects/networking"

  # Infrastructure
  tf_dev_folder_id = var.tf_dev_folder_id
  billing_account  = var.billing_account
  folder_ids       = var.folder_ids

  networking_dev_project_id  = var.networking.development_project_id
  networking_prod_project_id = var.networking.production_project_id
  
  region           = var.region
  dev_subnet_cidr  = var.networking.dev_subnet_cidr
  prod_subnet_cidr = var.networking.prod_subnet_cidr
  
  create_dev_nat  = var.networking.create_dev_nat
  create_prod_nat = var.networking.create_prod_nat
  
  common_labels = var.common_labels
}

# ========================================
# Monitoring Project
# ========================================

module "monitoring" {
  count  = var.monitoring != null ? 1 : 0
  source = "./projects/monitoring"

  # Infrastructure
  tf_dev_folder_id = var.tf_dev_folder_id
  billing_account  = var.billing_account
  folder_ids       = var.folder_ids

  monitoring_project_id = var.monitoring.project_id
  common_labels         = var.common_labels
}

# ========================================
# Data Analytics Project
# ========================================

module "data_analytics" {
 count  = var.data_analytics != null ? 1 : 0
 source = "./projects/data-analytics"

 # Infrastructure
 tf_dev_folder_id = var.tf_dev_folder_id
 billing_account  = var.billing_account
 folder_ids       = var.folder_ids

 looker_dev_project_id  = var.data_analytics.looker_dev_project_id
 looker_prod_project_id = var.data_analytics.looker_prod_project_id
 
 common_labels = var.common_labels
}
