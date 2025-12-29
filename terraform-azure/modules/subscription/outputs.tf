output "vnet_id" {
  description = "Virtual Network ID"
  value       = module.vnet.vnet_id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = module.vnet.vnet_name
}

output "networking_resource_group_name" {
  description = "Networking resource group name"
  value       = azurerm_resource_group.networking.name
}

output "storage_account_id" {
  description = "Storage Account ID"
  value       = module.storage.storage_account_id
}

output "storage_account_name" {
  description = "Storage Account name"
  value       = module.storage.storage_account_name
}

output "key_vault_id" {
  description = "Key Vault ID"
  value       = var.enable_key_vault ? module.key_vault[0].key_vault_id : null
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = var.enable_key_vault ? module.key_vault[0].key_vault_uri : null
}

output "data_factory_id" {
  description = "Data Factory ID"
  value       = var.enable_data_factory ? module.data_factory[0].data_factory_id : null
}

output "data_factory_name" {
  description = "Data Factory name"
  value       = var.enable_data_factory ? module.data_factory[0].data_factory_name : null
}

output "databricks_workspace_id" {
  description = "Databricks Workspace ID"
  value       = var.enable_databricks ? module.databricks[0].workspace_id : null
}

output "databricks_workspace_url" {
  description = "Databricks Workspace URL"
  value       = var.enable_databricks ? module.databricks[0].workspace_url : null
}

output "private_dns_zone_ids" {
  description = "Private DNS Zone IDs (only for hub/core)"
  value       = var.is_hub ? module.private_dns[0].dns_zone_ids : {}
}
