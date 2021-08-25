locals {
  name_suffix = "${var.environment}${local.location_map[var.location]}${random_string.root.result}"
  location_map = {
    australiaeast      = "aue"
    australiasoutheast = "aus"
  }
}

# Random suffix for naming convention
resource "random_string" "root" {
  length  = 5
  upper   = false
  number  = true
  special = false
}

##################################
# Data Sources
##################################

data "azurerm_resource_group" "shared" {
  name = var.resource_group_name
}

##################################
# Managed Identity
##################################

resource "azurerm_user_assigned_identity" "core" {
  name                = "uai-${local.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = data.azurerm_resource_group.shared.tags
}

resource "azurerm_role_assignment" "core" {
  scope                = azurerm_user_assigned_identity.core.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_cluster_object_id
}

##################################
# Azure Data Factory
##################################

# Create Azure Data Factory
module "azure-data-factory" {
  source              = "../modules/azure_data_factory"
  data_factory_name   = "adf-${local.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = data.azurerm_resource_group.shared.tags
  rbac_object_ids     = var.rbac_object_ids
  uai_principal_id    = azurerm_user_assigned_identity.core.principal_id
}

##################################
# Key Vault - Application Access
##################################

# Create the Key Vault
module "key-vault-core" {
  source              = "../modules/azure_key_vault"
  location            = var.location
  tags                = data.azurerm_resource_group.shared.tags
  resource_group_name = var.resource_group_name
  name_suffix         = local.name_suffix
  rbac_object_ids     = var.rbac_object_ids
  uai_principal_id    = azurerm_user_assigned_identity.core.principal_id
}

# Call the Private Link module
module "private-link-key-vault" {
  source = "../modules/azure_private_link"

  private_link_nic_location             = var.location
  private_link_nic_resource_group_name  = var.resource_group_name
  private_link_subresource_types        = ["vault"]
  private_link_resource_name            = module.key-vault-core.key_vault_name
  private_link_resource_id              = module.key-vault-core.key_vault_id
  private_link_vnet_resource_group_name = var.private_link_vnet_resource_group_name
  private_link_vnet_subnet_name         = var.private_link_vnet_subnet_name
  private_link_vnet_name                = var.private_link_vnet_name
}

module "azure_storage_account_01" {
  source               = "../modules/azure_storage_account"
  location             = var.location
  tags                 = data.azurerm_resource_group.shared.tags
  resource_group_name  = var.resource_group_name
  storage_account_name = "sa${local.name_suffix}01"
  rbac_object_ids      = var.rbac_object_ids
  uai_principal_id     = azurerm_user_assigned_identity.core.principal_id
}

module "azure_storage_account_02" {
  source               = "../modules/azure_storage_account"
  location             = var.location
  tags                 = data.azurerm_resource_group.shared.tags
  resource_group_name  = var.resource_group_name
  storage_account_name = "sa${local.name_suffix}02"
  rbac_object_ids      = var.rbac_object_ids
  uai_principal_id     = azurerm_user_assigned_identity.core.principal_id
}