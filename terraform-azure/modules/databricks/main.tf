# Databricks Workspace with VNet Injection
resource "azurerm_databricks_workspace" "main" {
  name                        = "dbw-${var.company_name}-${var.region_code}-01-${var.environment}"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku                         = "premium"
  managed_resource_group_name = var.managed_resource_group_name
  
  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = var.vnet_id
    public_subnet_name                                   = var.public_subnet_name
    private_subnet_name                                  = var.private_subnet_name
    public_subnet_network_security_group_association_id  = var.public_subnet_nsg_id
    private_subnet_network_security_group_association_id = var.private_subnet_nsg_id
  }
  
  tags = var.tags
}
