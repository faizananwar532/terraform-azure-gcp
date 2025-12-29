output "vnet_id" {
  description = "Virtual Network ID"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = azurerm_virtual_network.main.name
}

output "data_products_subnet_id" {
  description = "Data Products Subnet ID"
  value       = azurerm_subnet.data_products.id
}

output "db_public_subnet_id" {
  description = "Databricks Public Subnet ID"
  value       = azurerm_subnet.db_public.id
}

output "db_private_subnet_id" {
  description = "Databricks Private Subnet ID"
  value       = azurerm_subnet.db_private.id
}

output "db_public_subnet_name" {
  description = "Databricks Public Subnet name"
  value       = azurerm_subnet.db_public.name
}

output "db_private_subnet_name" {
  description = "Databricks Private Subnet name"
  value       = azurerm_subnet.db_private.name
}

output "db_public_subnet_nsg_id" {
  description = "Databricks Public Subnet NSG ID"
  value       = azurerm_network_security_group.db_public.id
}

output "db_private_subnet_nsg_id" {
  description = "Databricks Private Subnet NSG ID"
  value       = azurerm_network_security_group.db_private.id
}
