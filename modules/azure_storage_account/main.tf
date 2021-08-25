##################################
# Storage Account
##################################
locals {
  # Access roles to be assigned
  storage_account_roles = [
    "Storage Blob Data Contributor",
  ]
  # Given Object Ids are assigned to above storage account roles
  rbac_mappings = flatten([for role_name in local.storage_account_roles :
    [for object_id in var.rbac_object_ids : {
      role_name = role_name
      object_id = object_id
      }
    ]
  ])
}

#  Create a storage account in Azure
resource "azurerm_storage_account" "acme" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account_account_tier
  account_replication_type = var.storage_account_account_replication_type
  tags = var.tags
}

##################################
# Role Assignments
##################################
resource "azurerm_role_assignment" "rbac_mappings" {
  for_each = {
    for rbac_mapping in local.rbac_mappings : "${rbac_mapping.role_name}.${rbac_mapping.object_id}}" => rbac_mapping
  }
  scope                = azurerm_storage_account.acme.id
  role_definition_name = each.value.role_name
  principal_id         = each.value.object_id
}

resource "azurerm_role_assignment" "rbac_mappings_uai" {
  for_each             = toset(local.storage_account_roles)
  scope                = azurerm_storage_account.acme.id
  role_definition_name = each.key
  principal_id         = var.uai_principal_id
}
