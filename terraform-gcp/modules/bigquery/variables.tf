variable "project_id" {
  description = "The GCP project ID where the BigQuery dataset will be created"
  type        = string
}

variable "dataset_id" {
  description = "A unique ID for the BigQuery dataset"
  type        = string
}

variable "friendly_name" {
  description = "A descriptive name for the dataset"
  type        = string
  default     = null
}

variable "description" {
  description = "A user-friendly description of the dataset"
  type        = string
  default     = null
}

variable "location" {
  description = "The geographic location where the dataset should reside"
  type        = string
  default     = "UK"
}

variable "default_table_expiration_ms" {
  description = "The default lifetime of all tables in the dataset, in milliseconds"
  type        = number
  default     = null
}

variable "delete_contents_on_destroy" {
  description = "If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present"
  type        = bool
  default     = false
}

variable "labels" {
  description = "A mapping of labels to assign to the dataset"
  type        = map(string)
  default     = {}
}

variable "access_roles" {
  description = "List of access roles to grant on the dataset"
  type = list(object({
    role           = string
    user_by_email  = optional(string)
    group_by_email = optional(string)
    special_group  = optional(string)
  }))
  default = []
}

variable "dataset_iam_members" {
  description = "Map of IAM members to grant specific roles on the dataset"
  type = map(object({
    role   = string
    member = string
  }))
  default = {}
}

variable "kms_key_name" {
  description = "The Cloud KMS key name used for encryption"
  type        = string
  default     = null
}

variable "tables" {
  description = "A map of tables to create in the dataset"
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
