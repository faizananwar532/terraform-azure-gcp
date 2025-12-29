# Management Group
resource "azurerm_management_group" "analytics_data_platform" {
  display_name = "Analytics Data Platform"
  # parent_management_group_id defaults to Tenant Root Group
}

# Dev Subscription Module
module "dev_subscription" {
  source = "./modules/subscription"
  
  providers = {
    azurerm = azurerm.dev
  }

  subscription_id          = var.subscription_ids.dev
  company_name             = var.company_name
  region_code              = var.region_code
  environment              = "dev"
  location                 = var.location
  vnet_address_space       = var.vnet_address_spaces.dev
  subnet_config            = var.subnet_config.dev
  core_vnet_id            = module.core_subscription.vnet_id
  core_resource_group_name = module.core_subscription.networking_resource_group_name
  
  # Private DNS Zone IDs from Core
  private_dns_zone_ids = module.core_subscription.private_dns_zone_ids
  
  # Enable resources specific to dev
  enable_data_factory = true
  enable_databricks   = true
  enable_key_vault    = true
  
  depends_on = [azurerm_management_group.analytics_data_platform]
}

# Test Subscription Module
module "test_subscription" {
  source = "./modules/subscription"
  
  providers = {
    azurerm = azurerm.test
  }

  subscription_id          = var.subscription_ids.test
  company_name             = var.company_name
  region_code              = var.region_code
  environment              = "test"
  location                 = var.location
  vnet_address_space       = var.vnet_address_spaces.test
  subnet_config            = var.subnet_config.test
  core_vnet_id            = module.core_subscription.vnet_id
  core_resource_group_name = module.core_subscription.networking_resource_group_name
  
  # Private DNS Zone IDs from Core
  private_dns_zone_ids = module.core_subscription.private_dns_zone_ids
  
  # Enable resources specific to test
  enable_data_factory = true
  enable_databricks   = true
  enable_key_vault    = true
  
  depends_on = [azurerm_management_group.analytics_data_platform]
}

# Prod Subscription Module
module "prod_subscription" {
  source = "./modules/subscription"
  
  providers = {
    azurerm = azurerm.prod
  }

  subscription_id          = var.subscription_ids.prod
  company_name             = var.company_name
  region_code              = var.region_code
  environment              = "prod"
  location                 = var.location
  vnet_address_space       = var.vnet_address_spaces.prod
  subnet_config            = var.subnet_config.prod
  core_vnet_id            = module.core_subscription.vnet_id
  core_resource_group_name = module.core_subscription.networking_resource_group_name
  
  # Private DNS Zone IDs from Core
  private_dns_zone_ids = module.core_subscription.private_dns_zone_ids
  
  # Enable resources specific to prod
  enable_data_factory = true
  enable_databricks   = true
  enable_key_vault    = true
  
  depends_on = [azurerm_management_group.analytics_data_platform]
}

# Analytics Subscription Module
module "analytics_subscription" {
  source = "./modules/subscription"
  
  providers = {
    azurerm = azurerm.analytics
  }

  subscription_id          = var.subscription_ids.analytics
  company_name             = var.company_name
  region_code              = var.region_code
  environment              = "analytics"
  location                 = var.location
  vnet_address_space       = var.vnet_address_spaces.analytics
  subnet_config            = var.subnet_config.analytics
  core_vnet_id            = module.core_subscription.vnet_id
  core_resource_group_name = module.core_subscription.networking_resource_group_name
  
  # Private DNS Zone IDs from Core
  private_dns_zone_ids = module.core_subscription.private_dns_zone_ids
  
  # Enable resources specific to analytics
  enable_data_factory = false
  enable_databricks   = true
  enable_key_vault    = true
  
  depends_on = [azurerm_management_group.analytics_data_platform]
}

# Core Subscription Module (Hub)
module "core_subscription" {
  source = "./modules/subscription"
  
  providers = {
    azurerm = azurerm.core
  }

  subscription_id    = var.subscription_ids.core
  company_name       = var.company_name
  region_code        = var.region_code
  environment        = "core"
  location           = var.location
  vnet_address_space = var.vnet_address_spaces.core
  subnet_config      = var.subnet_config.core
  is_hub             = true
  
  # Core doesn't need these since it's the hub
  core_vnet_id             = ""
  core_resource_group_name = ""
  private_dns_zone_ids     = {}
  
  # Enable resources specific to core
  enable_data_factory = false
  enable_databricks   = false
  enable_key_vault    = false
  
  # Core has different storage account naming
  storage_account_suffix = "dbms01"
  
  depends_on = [azurerm_management_group.analytics_data_platform]
}

# VNet Peerings from Core to Spokes
# These must be created using the Core provider to avoid cross-subscription issues

resource "azurerm_virtual_network_peering" "core_to_dev" {
  provider = azurerm.core
  
  name                         = "peer-core-to-dev"
  resource_group_name          = module.core_subscription.networking_resource_group_name
  virtual_network_name         = module.core_subscription.vnet_name
  remote_virtual_network_id    = module.dev_subscription.vnet_id
  
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  
  depends_on = [module.core_subscription, module.dev_subscription]
}

resource "azurerm_virtual_network_peering" "core_to_test" {
  provider = azurerm.core
  
  name                         = "peer-core-to-test"
  resource_group_name          = module.core_subscription.networking_resource_group_name
  virtual_network_name         = module.core_subscription.vnet_name
  remote_virtual_network_id    = module.test_subscription.vnet_id
  
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  
  depends_on = [module.core_subscription, module.test_subscription]
}

resource "azurerm_virtual_network_peering" "core_to_prod" {
  provider = azurerm.core
  
  name                         = "peer-core-to-prod"
  resource_group_name          = module.core_subscription.networking_resource_group_name
  virtual_network_name         = module.core_subscription.vnet_name
  remote_virtual_network_id    = module.prod_subscription.vnet_id
  
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  
  depends_on = [module.core_subscription, module.prod_subscription]
}

resource "azurerm_virtual_network_peering" "core_to_analytics" {
  provider = azurerm.core
  
  name                         = "peer-core-to-analytics"
  resource_group_name          = module.core_subscription.networking_resource_group_name
  virtual_network_name         = module.core_subscription.vnet_name
  remote_virtual_network_id    = module.analytics_subscription.vnet_id
  
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  
  depends_on = [module.core_subscription, module.analytics_subscription]
}
