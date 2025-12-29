variable "company_name" {
  description = "Company 3 letter name (lower case)"
  type        = string
}

variable "region_code" {
  description = "Three letter abbreviation of region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "storage_account_suffix" {
  description = "Suffix for storage account name"
  type        = string
  default     = "01"
}

variable "create_datastore_container" {
  description = "Whether to create fs-datastore container"
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "Subnet ID for private endpoints"
  type        = string
}

variable "private_dns_zone_ids" {
  description = "Map of private DNS zone IDs"
  type        = map(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
