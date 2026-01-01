# Data Factory
resource "azurerm_data_factory" "main" {
  name                = "adf-${var.company_name}-${var.region_code}-01-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  
  identity {
    type = "SystemAssigned"
  }
  
  tags = var.tags
}

# Private Endpoint for Data Factory
resource "azurerm_private_endpoint" "datafactory" {
  name                = "pep-${azurerm_data_factory.main.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${azurerm_data_factory.main.name}"
    private_connection_resource_id = azurerm_data_factory.main.id
    is_manual_connection           = false
    subresource_names              = ["dataFactory"]
  }

  private_dns_zone_group {
    name                 = "pdz-group-datafactory"
    private_dns_zone_ids = var.private_dns_zone_id != null && var.private_dns_zone_id != "" ? [var.private_dns_zone_id] : []
  }

  # Custom NIC name with nic- prefix
  custom_network_interface_name = "nic-${azurerm_data_factory.main.name}"
}
