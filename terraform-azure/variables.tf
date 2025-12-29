variable "company_name" {
  description = "Company 3 letter name (lower case)"
  type        = string
  validation {
    condition     = length(var.company_name) == 3
    error_message = "Company name must be exactly 3 characters."
  }
}

variable "region_code" {
  description = "Three letter abbreviation of region (e.g., 'uks' for UK South)"
  type        = string
  validation {
    condition     = length(var.region_code) == 3
    error_message = "Region code must be exactly 3 characters."
  }
}

variable "location" {
  description = "Azure region for resources (e.g., 'uksouth')"
  type        = string
  default     = "uksouth"
}

variable "subscription_ids" {
  description = "Map of subscription IDs for each environment"
  type = object({
    dev       = string
    test      = string
    prod      = string
    analytics = string
    core      = string
  })
}

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

variable "vnet_address_spaces" {
  description = "VNet address spaces for each environment"
  type = object({
    dev       = string
    test      = string
    prod      = string
    analytics = string
    core      = string
  })
}

variable "subnet_config" {
  description = "Subnet configuration for each environment"
  type = object({
    dev = object({
      data_products_prefix = string
      db_public_prefix     = string
      db_private_prefix    = string
    })
    test = object({
      data_products_prefix = string
      db_public_prefix     = string
      db_private_prefix    = string
    })
    prod = object({
      data_products_prefix = string
      db_public_prefix     = string
      db_private_prefix    = string
    })
    analytics = object({
      data_products_prefix = string
      db_public_prefix     = string
      db_private_prefix    = string
    })
    core = object({
      data_products_prefix = string
      db_public_prefix     = string
      db_private_prefix    = string
    })
  })
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "Analytics Data Platform"
  }
}
