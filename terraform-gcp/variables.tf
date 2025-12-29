# ========================================
# CENTRALIZED VARIABLES FILE
# All project configurations managed from here
# ========================================

# ========================================
# Organization & Folder Structure
# ========================================

variable "organization_id" {
  description = "The GCP Organization ID"
  type        = string
}

variable "tf_dev_folder_id" {
  description = "The tf-dev folder ID (parent of all project folders)"
  type        = string
}

variable "billing_account" {
  description = "The billing account ID for all projects"
  type        = string
}

# ========================================
# Folder IDs (for existing manually created folders)
# ========================================

variable "folder_ids" {
  description = "Map of folder IDs for each module"
  type = object({
    data_analytics = string
    data_core      = string
    monitoring     = string
    networking     = string
    security       = string
    # Data Core subfolders
    data_core_archive     = string
    data_core_development = string
    data_core_production  = string
    # Data Analytics subfolders
    looker = string
  })
}

# ========================================
# Global Configuration
# ========================================

variable "company_name" {
  description = "The company name in lowercase (C_NAME parameter)"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID for Terraform management"
  type        = string
}

variable "region" {
  description = "The default GCP region (C_REGION parameter)"
  type        = string
  default     = "europe-west2"
}

variable "common_labels" {
  description = "Common labels to apply to all resources"
  type        = map(string)
  default = {
    managed_by = "terraform"
    team       = "data-engineering"
  }
}

# ========================================
# Data Core Configuration
# ========================================

variable "data_core" {
  description = "Complete Data Core project configuration"
  type = object({
    # Project IDs
    archive_project_id     = string
    development_project_id = string
    production_project_id  = string

    # Dataset Configuration
    archive_dataset_id     = optional(string, "archive_data")
    development_dataset_id = optional(string, "data_core_dev")
    production_dataset_id  = optional(string, "data_core_prod")
    
    # Location (defaults to var.region if not specified)
    location = optional(string)

    # Development Settings
    dev_table_expiration_ms = optional(number, 2592000000) # 30 days

    # Archive Access Control
    archive_access_roles = optional(list(object({
      role           = string
      user_by_email  = optional(string)
      group_by_email = optional(string)
      special_group  = optional(string)
    })), [])
    
    archive_iam_members = optional(map(object({
      role   = string
      member = string
    })), {})

    # Development Access Control
    development_access_roles = optional(list(object({
      role           = string
      user_by_email  = optional(string)
      group_by_email = optional(string)
      special_group  = optional(string)
    })), [])
    
    development_iam_members = optional(map(object({
      role   = string
      member = string
    })), {})

    # Production Access Control
    production_access_roles = optional(list(object({
      role           = string
      user_by_email  = optional(string)
      group_by_email = optional(string)
      special_group  = optional(string)
    })), [])
    
    production_iam_members = optional(map(object({
      role   = string
      member = string
    })), {})

    # Development Tables
    development_tables = optional(map(object({
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
    })), {})

    # Production Tables
    production_tables = optional(map(object({
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
    })), {})

    # Encryption
    production_kms_key_name = optional(string, null)
    
    # GCS Buckets
    development_bucket_name = optional(string)
    production_bucket_name  = optional(string)
    
    development_bucket_iam_members = optional(map(object({
      role   = string
      member = string
    })), {})
    
    production_bucket_iam_members = optional(map(object({
      role   = string
      member = string
    })), {})
  })
}

# ========================================
# Security Configuration
# ========================================

variable "security" {
  description = "Security project configuration"
  type = object({
    project_id = string
  })
  default = null
}

# ========================================
# Networking Configuration
# ========================================

variable "networking" {
  description = "Networking project configuration"
  type = object({
    development_project_id = string
    production_project_id  = string
    
    # Subnet CIDRs
    dev_subnet_cidr  = optional(string, "10.20.0.0/24")
    prod_subnet_cidr = optional(string, "10.21.0.0/24")
    
    # NAT Configuration
    create_dev_nat  = optional(bool, true)
    create_prod_nat = optional(bool, true)
  })
  default = null
}

# ========================================
# Monitoring Configuration
# ========================================

variable "monitoring" {
  description = "Monitoring project configuration"
  type = object({
    project_id = string
  })
  default = null
}

# ========================================
# Data Analytics Configuration
# ========================================

variable "data_analytics" {
  description = "Data Analytics project configuration"
  type = object({
    looker_dev_project_id  = string
    looker_prod_project_id = string
  })
  default = null
}
