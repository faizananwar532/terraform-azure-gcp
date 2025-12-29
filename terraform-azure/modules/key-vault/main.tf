# Get current client config for access
data "azurerm_client_config" "current" {}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                       = "kv-${var.company_name}-${var.region_code}-01-${var.environment}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 7
  
  # Use RBAC for access control
  enable_rbac_authorization = true
  
  tags = var.tags
}

# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "keyvault" {
  name                = "pep-${azurerm_key_vault.main.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${azurerm_key_vault.main.name}"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id != null && var.private_dns_zone_id != "" ? [1] : []
    content {
      name                 = "pdz-group-keyvault"
      private_dns_zone_ids = [var.private_dns_zone_id]
    }
  }
}
