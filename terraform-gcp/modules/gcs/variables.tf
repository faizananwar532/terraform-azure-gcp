variable "project_id" {
  description = "The GCP project ID where the bucket will be created"
  type        = string
}

variable "bucket_name" {
  description = "The name of the GCS bucket"
  type        = string
}

variable "location" {
  description = "The location of the bucket"
  type        = string
  default     = "US"
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects"
  type        = bool
  default     = false
}

variable "enable_hierarchical_namespace" {
  description = "Enable hierarchical namespace for better file organization"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules to configure"
  type = list(object({
    action = object({
      type          = string
      storage_class = optional(string)
    })
    condition = object({
      age                   = optional(number)
      created_before        = optional(string)
      with_state            = optional(string)
      matches_storage_class = optional(list(string))
      num_newer_versions    = optional(number)
    })
  }))
  default = []
}

variable "kms_key_name" {
  description = "The Cloud KMS key name for encryption"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels to apply to the bucket"
  type        = map(string)
  default     = {}
}

variable "iam_members" {
  description = "Map of IAM members and their roles"
  type = map(object({
    role   = string
    member = string
  }))
  default = {}
}
