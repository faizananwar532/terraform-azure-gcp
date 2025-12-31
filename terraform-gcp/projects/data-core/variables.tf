# Infrastructure Variables
variable "tf_dev_folder_id" {
  description = "The tf-dev parent folder ID"
  type        = string
}

variable "billing_account" {
  description = "The billing account ID"
  type        = string
}

# Project IDs (to be provided - projects created manually)
variable "archive_project_id" {
  description = "The GCP project ID for the Archive project"
  type        = string
}

variable "development_project_id" {
  description = "The GCP project ID for the Data Core Development project"
  type        = string
}

variable "production_project_id" {
  description = "The GCP project ID for the Data Core Production project"
  type        = string
}

# Dataset Configuration
variable "archive_dataset_id" {
  description = "BigQuery dataset ID for archive data"
  type        = string
  default     = "archive_data"
}

variable "development_dataset_id" {
  description = "BigQuery dataset ID for development data"
  type        = string
  default     = "data_core_dev"
}

variable "production_dataset_id" {
  description = "BigQuery dataset ID for production data"
  type        = string
  default     = "data_core_prod"
}

# Location
variable "location" {
  description = "The geographic location for BigQuery datasets and GCS buckets (C_REGION)"
  type        = string
  default     = "europe-west2"
}

# Common Labels
variable "common_labels" {
  description = "Common labels to apply to all resources"
  type        = map(string)
  default = {
    managed_by = "terraform"
    team       = "data-engineering"
  }
}

# Development Configuration
variable "dev_table_expiration_ms" {
  description = "Default table expiration for development datasets (in milliseconds)"
  type        = number
  default     = 2592000000 # 30 days
}

variable "development_tables" {
  description = "Map of tables to create in the development dataset"
  type = map(object({
    description = optional(string)
    schema      = optional(string)
    time_partitioning = optional(object({
      type                     = string
      expiration_ms            = optional(number)
      field                    = optional(string)
      require_partition_filter = optional(bool)
    }))
    clustering = optional(object({
      fields = list(string)
    }))
    labels = optional(map(string))
  }))
  default = {}
}

variable "production_tables" {
  description = "Map of tables to create in the production dataset"
  type = map(object({
    description = optional(string)
    schema      = optional(string)
    time_partitioning = optional(object({
      type                     = string
      expiration_ms            = optional(number)
      field                    = optional(string)
      require_partition_filter = optional(bool)
    }))
    clustering = optional(object({
      fields = list(string)
    }))
    labels = optional(map(string))
  }))
  default = {}
}

# Access Control - Archive
variable "archive_access_roles" {
  description = "Access roles for the archive dataset"
  type = list(object({
    role           = string
    user_by_email  = optional(string)
    group_by_email = optional(string)
    special_group  = optional(string)
  }))
  default = []
}

variable "archive_iam_members" {
  description = "IAM members for the archive dataset"
  type = map(object({
    role   = string
    member = string
  }))
  default = {}
}

# Access Control - Development
variable "development_access_roles" {
  description = "Access roles for the development dataset"
  type = list(object({
    role           = string
    user_by_email  = optional(string)
    group_by_email = optional(string)
    special_group  = optional(string)
  }))
  default = []
}

variable "development_iam_members" {
  description = "IAM members for the development dataset"
  type = map(object({
    role   = string
    member = string
  }))
  default = {}
}

# Access Control - Production
variable "production_access_roles" {
  description = "Access roles for the production dataset"
  type = list(object({
    role           = string
    user_by_email  = optional(string)
    group_by_email = optional(string)
    special_group  = optional(string)
  }))
  default = []
}

variable "production_iam_members" {
  description = "IAM members for the production dataset"
  type = map(object({
    role   = string
    member = string
  }))
  default = {}
}

# Encryption
variable "production_kms_key_name" {
  description = "KMS key name for production dataset encryption"
  type        = string
  default     = null
}

# GCS Buckets
variable "development_bucket_name" {
  description = "Name of the GCS bucket for development"
  type        = string
}

variable "production_bucket_name" {
  description = "Name of the GCS bucket for production"
  type        = string
}

variable "development_bucket_iam_members" {
  description = "IAM members for the development GCS bucket"
  type = map(object({
    role   = string
    member = string
  }))
  default = {}
}

variable "production_bucket_iam_members" {
  description = "IAM members for the production GCS bucket"
  type = map(object({
    role   = string
    member = string
  }))
  default = {}
}
