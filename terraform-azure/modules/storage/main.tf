# Storage Account Name (must be globally unique, lowercase, no hyphens)
locals {
  storage_name = "${var.company_name}${var.region_code}${var.environment}${var.storage_account_suffix}"
}

# Storage Account (Azure Data Lake Storage Gen 2)
resource "azurerm_storage_account" "main" {
  name                     = local.storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"
  is_hns_enabled           = true  # Hierarchical Namespace for ADLS Gen2
  
  tags = var.tags
}

# Storage Container (fs-datastore) for dev, test, prod environments
resource "azurerm_storage_container" "datastore" {
  count                 = var.create_datastore_container ? 1 : 0
  name                  = "fs-datastore"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Private Endpoint for Blob
resource "azurerm_private_endpoint" "blob" {
  name                = "pep-${azurerm_storage_account.main.name}-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.main.name}-blob"
    private_connection_resource_id = azurerm_storage_account.main.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  dynamic "private_dns_zone_group" {
    for_each = length(var.private_dns_zone_ids) > 0 && lookup(var.private_dns_zone_ids, "blob", null) != null ? [1] : []
    content {
      name                 = "pdz-group-blob"
      private_dns_zone_ids = [var.private_dns_zone_ids["blob"]]
    }
  }
}

# Private Endpoint for DFS (Data Lake)
resource "azurerm_private_endpoint" "dfs" {
  name                = "pep-${azurerm_storage_account.main.name}-dfs"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.main.name}-dfs"
    private_connection_resource_id = azurerm_storage_account.main.id
    is_manual_connection           = false
    subresource_names              = ["dfs"]
  }

  dynamic "private_dns_zone_group" {
    for_each = length(var.private_dns_zone_ids) > 0 && lookup(var.private_dns_zone_ids, "dfs", null) != null ? [1] : []
    content {
      name                 = "pdz-group-dfs"
      private_dns_zone_ids = [var.private_dns_zone_ids["dfs"]]
    }
  }
}
