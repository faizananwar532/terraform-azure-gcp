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

variable "vnet_address_space" {
  description = "Address space for the VNet (e.g., '10.16.0.0/16')"
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
