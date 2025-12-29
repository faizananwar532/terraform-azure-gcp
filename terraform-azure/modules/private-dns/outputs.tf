output "dns_zone_ids" {
  description = "Map of private DNS zone IDs"
  value = {
    blob        = azurerm_private_dns_zone.blob.id
    dfs         = azurerm_private_dns_zone.dfs.id
    keyvault    = azurerm_private_dns_zone.keyvault.id
    datafactory = azurerm_private_dns_zone.datafactory.id
  }
}

output "blob_dns_zone_id" {
  description = "Blob storage private DNS zone ID"
  value       = azurerm_private_dns_zone.blob.id
}

output "dfs_dns_zone_id" {
  description = "DFS storage private DNS zone ID"
  value       = azurerm_private_dns_zone.dfs.id
}

output "keyvault_dns_zone_id" {
  description = "Key Vault private DNS zone ID"
  value       = azurerm_private_dns_zone.keyvault.id
}

output "datafactory_dns_zone_id" {
  description = "Data Factory private DNS zone ID"
  value       = azurerm_private_dns_zone.datafactory.id
}
