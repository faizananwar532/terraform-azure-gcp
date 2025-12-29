# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.company_name}-${var.region_code}${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

# Calculate subnet address prefixes based on VNet address space or use provided config
locals {
  # If subnet_config is provided, use it; otherwise calculate from VNet address space
  use_provided_config = var.subnet_config != null
  
  # Extract the base network (e.g., "10.16" from "10.16.0.0/16") for auto-calculation
  base_network = join(".", slice(split(".", split("/", var.vnet_address_space)[0]), 0, 2))
  
  # Use provided config or fall back to calculated values
  data_products_subnet_prefix = local.use_provided_config ? var.subnet_config.data_products_prefix : "${local.base_network}.0.0/24"
  db_public_subnet_prefix     = local.use_provided_config ? var.subnet_config.db_public_prefix : "${local.base_network}.1.0/25"
  db_private_subnet_prefix    = local.use_provided_config ? var.subnet_config.db_private_prefix : "${local.base_network}.2.0/25"
}

# Data Products Subnet
resource "azurerm_subnet" "data_products" {
  name                 = "snet-data-products"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.data_products_subnet_prefix]
}

# Databricks Public Subnet
resource "azurerm_subnet" "db_public" {
  name                 = "snet-db-public"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.db_public_subnet_prefix]
  
  delegation {
    name = "databricks-delegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Databricks Private Subnet
resource "azurerm_subnet" "db_private" {
  name                 = "snet-db-private"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.db_private_subnet_prefix]
  
  delegation {
    name = "databricks-delegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Network Security Group for Databricks Public Subnet
resource "azurerm_network_security_group" "db_public" {
  name                = "nsg-db-public-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Network Security Group for Databricks Private Subnet
resource "azurerm_network_security_group" "db_private" {
  name                = "nsg-db-private-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Associate NSG with Public Subnet
resource "azurerm_subnet_network_security_group_association" "db_public" {
  subnet_id                 = azurerm_subnet.db_public.id
  network_security_group_id = azurerm_network_security_group.db_public.id
}

# Associate NSG with Private Subnet
resource "azurerm_subnet_network_security_group_association" "db_private" {
  subnet_id                 = azurerm_subnet.db_private.id
  network_security_group_id = azurerm_network_security_group.db_private.id
}
