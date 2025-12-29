variable "tf_dev_folder_id" {
  description = "The tf-dev parent folder ID"
  type        = string
}

variable "billing_account" {
  description = "The billing account ID"
  type        = string
}

variable "folder_ids" {
  description = "Map of folder IDs"
  type = object({
    data_analytics        = string
    data_core             = string
    monitoring            = string
    networking            = string
    security              = string
    data_core_archive     = string
    data_core_development = string
    data_core_production  = string
    looker                = string
  })
}

variable "monitoring_project_id" {
  description = "The GCP project ID for the Central Monitoring project"
  type        = string
}

variable "common_labels" {
  description = "Common labels to apply to all resources"
  type        = map(string)
  default = {
    managed_by = "terraform"
    team       = "monitoring"
  }
}
