# Data Core Project Configuration
#
# This configuration manages the Data Core project with BigQuery datasets and GCS buckets
# Projects are managed by Terraform and APIs are enabled automatically

# ============================================
# ARCHIVE PROJECT
# ============================================

# Archive Dataset
module "archive_dataset" {
  source = "../../modules/bigquery"

  project_id  = google_project.archive.project_id
  dataset_id  = var.archive_dataset_id
  location    = var.location
  description = "Archive dataset for long-term data storage"
  
  friendly_name = "Archive Data"
  
  default_table_expiration_ms = null # No expiration for archive data
  delete_contents_on_destroy  = false
  
  labels = merge(
    var.common_labels,
    {
      project     = "data-core"
      environment = "archive"
      data_tier   = "cold"
    }
  )
  
  access_roles = var.archive_access_roles
  dataset_iam_members = var.archive_iam_members
  
  depends_on = [google_project_service.archive_apis]
}

# ============================================
# DEVELOPMENT PROJECT
# ============================================

# Development Bronze Dataset
module "development_bronze_dataset" {
  source = "../../modules/bigquery"

  project_id  = google_project.development.project_id
  dataset_id  = "bronze"
  location    = var.location
  description = "Bronze - Raw Data (Dev)"
  
  friendly_name = "Development Bronze - Raw Data"
  
  default_table_expiration_ms = 2592000000 # 30 days
  delete_contents_on_destroy  = true
  
  labels = merge(
    var.common_labels,
    {
      project     = "data-core"
      environment = "development"
      data_tier   = "bronze"
    }
  )
  
  access_roles = var.development_access_roles
  dataset_iam_members = var.development_iam_members
  
  depends_on = [google_project_service.development_apis]
}

# Development Silver Dataset
module "development_silver_dataset" {
  source = "../../modules/bigquery"

  project_id  = google_project.development.project_id
  dataset_id  = "silver"
  location    = var.location
  description = "Silver - Cleansed Data (Dev)"
  
  friendly_name = "Development Silver - Cleansed Data"
  
  default_table_expiration_ms = 2592000000 # 30 days
  delete_contents_on_destroy  = true
  
  labels = merge(
    var.common_labels,
    {
      project     = "data-core"
      environment = "development"
      data_tier   = "silver"
    }
  )
  
  access_roles = var.development_access_roles
  dataset_iam_members = var.development_iam_members
  
  depends_on = [google_project_service.development_apis]
}

# Development Gold Dataset
module "development_gold_dataset" {
  source = "../../modules/bigquery"

  project_id  = google_project.development.project_id
  dataset_id  = "gold"
  location    = var.location
  description = "Gold - Business-Ready Data (Dev)"
  
  friendly_name = "Development Gold - Business-Ready Data"
  
  default_table_expiration_ms = 2592000000 # 30 days
  delete_contents_on_destroy  = true
  
  labels = merge(
    var.common_labels,
    {
      project     = "data-core"
      environment = "development"
      data_tier   = "gold"
    }
  )
  
  access_roles = var.development_access_roles
  dataset_iam_members = var.development_iam_members
  tables = var.development_tables
  
  depends_on = [google_project_service.development_apis]
}

# Development GCS Bucket
module "development_gcs_bucket" {
  source = "../../modules/gcs"

  project_id                      = google_project.development.project_id
  bucket_name                     = var.development_bucket_name
  location                        = var.location
  force_destroy                   = true
  enable_versioning               = true
  
  labels = merge(
    var.common_labels,
    {
      project     = "data-core"
      environment = "development"
    }
  )
  
  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age                   = 90
        with_state            = "ANY"
      }
    }
  ]
  
  iam_members = var.development_bucket_iam_members
  
  depends_on = [google_project_service.development_apis]
}

# ============================================
# PRODUCTION PROJECT
# ============================================

# Production Bronze Dataset
module "production_bronze_dataset" {
  source = "../../modules/bigquery"

  project_id  = google_project.production.project_id
  dataset_id  = "bronze"
  location    = var.location
  description = "Bronze - Raw Data (Prod)"
  
  friendly_name = "Production Bronze - Raw Data"
  
  default_table_expiration_ms = null
  delete_contents_on_destroy  = false
  
  labels = merge(
    var.common_labels,
    {
      project     = "data-core"
      environment = "production"
      data_tier   = "bronze"
      critical    = "true"
    }
  )
  
  access_roles = var.production_access_roles
  dataset_iam_members = var.production_iam_members
  
  kms_key_name = var.production_kms_key_name
  
  depends_on = [google_project_service.production_apis]
}

# Production Silver Dataset
module "production_silver_dataset" {
  source = "../../modules/bigquery"

  project_id  = google_project.production.project_id
  dataset_id  = "silver"
  location    = var.location
  description = "Silver - Cleansed Data (Prod)"
  
  friendly_name = "Production Silver - Cleansed Data"
  
  default_table_expiration_ms = null
  delete_contents_on_destroy  = false
  
  labels = merge(
    var.common_labels,
    {
      project     = "data-core"
      environment = "production"
      data_tier   = "silver"
      critical    = "true"
    }
  )
  
  access_roles = var.production_access_roles
  dataset_iam_members = var.production_iam_members
  
  kms_key_name = var.production_kms_key_name
  
  depends_on = [google_project_service.production_apis]
}

# Production Gold Dataset
module "production_gold_dataset" {
  source = "../../modules/bigquery"

  project_id  = google_project.production.project_id
  dataset_id  = "gold"
  location    = var.location
  description = "Gold - Business-Ready Data (Prod)"
  
  friendly_name = "Production Gold - Business-Ready Data"
  
  default_table_expiration_ms = null
  delete_contents_on_destroy  = false
  
  labels = merge(
    var.common_labels,
    {
      project     = "data-core"
      environment = "production"
      data_tier   = "gold"
      critical    = "true"
    }
  )
  
  access_roles = var.production_access_roles
  dataset_iam_members = var.production_iam_members
  
  kms_key_name = var.production_kms_key_name
  
  tables = var.production_tables
  
  depends_on = [google_project_service.production_apis]
}

# Production GCS Bucket
module "production_gcs_bucket" {
  source = "../../modules/gcs"

  project_id                      = google_project.production.project_id
  bucket_name                     = var.production_bucket_name
  location                        = var.location
  force_destroy                   = false
  enable_versioning               = true
  
  labels = merge(
    var.common_labels,
    {
      project     = "data-core"
      environment = "production"
      critical    = "true"
    }
  )
  
  iam_members = var.production_bucket_iam_members
  
  depends_on = [google_project_service.production_apis]
}
