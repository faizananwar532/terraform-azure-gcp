terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
      configuration_aliases = [azurerm]
    }
  }
}

# Resource Groups
resource "azurerm_resource_group" "integration" {
  name     = "rg-${var.company_name}-${var.region_code}-integration-${var.environment}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "networking" {
  name     = "rg-${var.company_name}-${var.region_code}-networking-${var.environment}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "storage" {
  name     = "rg-${var.company_name}-${var.region_code}-storage-${var.environment}"
  location = var.location
  tags     = var.tags
}

# Virtual Network Module
module "vnet" {
  source = "../networking"

  company_name        = var.company_name
  region_code         = var.region_code
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.networking.name
  vnet_address_space  = var.vnet_address_space
  subnet_config       = var.subnet_config
  tags                = var.tags
}

# Storage Account Module
module "storage" {
  source = "../storage"

  company_name        = var.company_name
  region_code         = var.region_code
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.storage.name
  storage_account_suffix = var.storage_account_suffix
  create_datastore_container = var.environment != "core"
  tags                = var.tags
  
  # Private Endpoint configuration
  subnet_id            = module.vnet.data_products_subnet_id
  private_dns_zone_ids = var.private_dns_zone_ids
}

# Key Vault Module (Dev, Test, Prod, Analytics only)
module "key_vault" {
  count  = var.enable_key_vault ? 1 : 0
  source = "../key-vault"

  company_name        = var.company_name
  region_code         = var.region_code
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.integration.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = var.tags
  
  # Private Endpoint configuration
  subnet_id           = module.vnet.data_products_subnet_id
  private_dns_zone_id = try(var.private_dns_zone_ids["keyvault"], "")
}

# Data Factory Module (Dev, Test, Prod only)
module "data_factory" {
  count  = var.enable_data_factory ? 1 : 0
  source = "../data-factory"

  company_name        = var.company_name
  region_code         = var.region_code
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.integration.name
  tags                = var.tags
  
  # Private Endpoint configuration
  subnet_id           = module.vnet.data_products_subnet_id
  private_dns_zone_id = try(var.private_dns_zone_ids["datafactory"], "")
}

# Databricks Module (Dev, Test, Prod, Analytics only)
module "databricks" {
  count  = var.enable_databricks ? 1 : 0
  source = "../databricks"

  company_name             = var.company_name
  region_code              = var.region_code
  environment              = var.environment
  location                 = var.location
  resource_group_name      = azurerm_resource_group.integration.name
  managed_resource_group_name = "mrg-dbw-${var.company_name}-${var.region_code}-Integration-${var.environment}"
  tags                     = var.tags
  
  # VNet Injection
  vnet_id                  = module.vnet.vnet_id
  public_subnet_name       = module.vnet.db_public_subnet_name
  private_subnet_name      = module.vnet.db_private_subnet_name
  public_subnet_nsg_id     = module.vnet.db_public_subnet_nsg_id
  private_subnet_nsg_id    = module.vnet.db_private_subnet_nsg_id
}

# VNet Peering to Core (if not the hub)
resource "azurerm_virtual_network_peering" "to_core" {
  count = var.is_hub ? 0 : 1
  
  name                      = "peer-${var.environment}-to-core"
  resource_group_name       = azurerm_resource_group.networking.name
  virtual_network_name      = module.vnet.vnet_name
  remote_virtual_network_id = var.core_vnet_id
  
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# Private DNS Zones (Only in Core/Hub)
module "private_dns" {
  count  = var.is_hub ? 1 : 0
  source = "../private-dns"

  resource_group_name = azurerm_resource_group.networking.name
  vnet_id            = module.vnet.vnet_id
  tags               = var.tags
}

# Data source for current client config
data "azurerm_client_config" "current" {}
