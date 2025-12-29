variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "company_name" {
  description = "Company 3 letter name (lower case)"
  type        = string
}

variable "region_code" {
  description = "Three letter abbreviation of region"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod, analytics, core)"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the VNet"
  type        = string
}

variable "subnet_config" {
  description = "Subnet configuration with address prefixes"
  type = object({
    data_products_prefix = string
    db_public_prefix     = string
    db_private_prefix    = string
  })
  default = null
}

variable "is_hub" {
  description = "Whether this is the hub (core) subscription"
  type        = bool
  default     = false
}

variable "core_vnet_id" {
  description = "VNet ID of the core hub (for spoke subscriptions)"
  type        = string
}

variable "core_resource_group_name" {
  description = "Resource group name in core subscription for peering"
  type        = string
}

variable "private_dns_zone_ids" {
  description = "Map of private DNS zone IDs from core subscription"
  type        = map(string)
  default     = {}
}

variable "enable_key_vault" {
  description = "Whether to create Key Vault"
  type        = bool
  default     = true
}

variable "enable_data_factory" {
  description = "Whether to create Data Factory"
  type        = bool
  default     = true
}

variable "enable_databricks" {
  description = "Whether to create Databricks workspace"
  type        = bool
  default     = true
}

variable "storage_account_suffix" {
  description = "Suffix for storage account name (01 for dev/test/prod/analytics, dbms01 for core)"
  type        = string
  default     = "01"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
