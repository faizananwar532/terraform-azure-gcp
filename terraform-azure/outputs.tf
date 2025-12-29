output "dev_outputs" {
  description = "Development subscription outputs"
  value = {
    vnet_id                  = module.dev_subscription.vnet_id
    vnet_name                = module.dev_subscription.vnet_name
    storage_account_id       = module.dev_subscription.storage_account_id
    storage_account_name     = module.dev_subscription.storage_account_name
    key_vault_id            = module.dev_subscription.key_vault_id
    data_factory_id         = module.dev_subscription.data_factory_id
    databricks_workspace_id = module.dev_subscription.databricks_workspace_id
  }
}

output "test_outputs" {
  description = "Test subscription outputs"
  value = {
    vnet_id                  = module.test_subscription.vnet_id
    vnet_name                = module.test_subscription.vnet_name
    storage_account_id       = module.test_subscription.storage_account_id
    storage_account_name     = module.test_subscription.storage_account_name
    key_vault_id            = module.test_subscription.key_vault_id
    data_factory_id         = module.test_subscription.data_factory_id
    databricks_workspace_id = module.test_subscription.databricks_workspace_id
  }
}

output "prod_outputs" {
  description = "Production subscription outputs"
  value = {
    vnet_id                  = module.prod_subscription.vnet_id
    vnet_name                = module.prod_subscription.vnet_name
    storage_account_id       = module.prod_subscription.storage_account_id
    storage_account_name     = module.prod_subscription.storage_account_name
    key_vault_id            = module.prod_subscription.key_vault_id
    data_factory_id         = module.prod_subscription.data_factory_id
    databricks_workspace_id = module.prod_subscription.databricks_workspace_id
  }
}

output "analytics_outputs" {
  description = "Analytics subscription outputs"
  value = {
    vnet_id                  = module.analytics_subscription.vnet_id
    vnet_name                = module.analytics_subscription.vnet_name
    storage_account_id       = module.analytics_subscription.storage_account_id
    storage_account_name     = module.analytics_subscription.storage_account_name
    key_vault_id            = module.analytics_subscription.key_vault_id
    databricks_workspace_id = module.analytics_subscription.databricks_workspace_id
  }
}

output "core_outputs" {
  description = "Core subscription outputs"
  value = {
    vnet_id                     = module.core_subscription.vnet_id
    vnet_name                   = module.core_subscription.vnet_name
    storage_account_id          = module.core_subscription.storage_account_id
    storage_account_name        = module.core_subscription.storage_account_name
    private_dns_zone_ids        = module.core_subscription.private_dns_zone_ids
    networking_resource_group_name = module.core_subscription.networking_resource_group_name
  }
}

output "management_group_id" {
  description = "Analytics Data Platform management group ID"
  value       = azurerm_management_group.analytics_data_platform.id
}
