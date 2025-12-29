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

variable "managed_resource_group_name" {
  description = "Managed resource group name for Databricks"
  type        = string
}

variable "vnet_id" {
  description = "Virtual Network ID for VNet injection"
  type        = string
}

variable "public_subnet_name" {
  description = "Public subnet name for Databricks"
  type        = string
}

variable "private_subnet_name" {
  description = "Private subnet name for Databricks"
  type        = string
}

variable "public_subnet_nsg_id" {
  description = "Public subnet NSG ID"
  type        = string
}

variable "private_subnet_nsg_id" {
  description = "Private subnet NSG ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
