data "azurerm_client_config" "current" {
}

locals {
  key_vault_key_permissions_full = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey",
  ]
  key_vault_secret_permissions_full = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set",
  ]
}

##################################
# Key Vault
##################################

resource "azurerm_key_vault" "module" {
  name                        = "kv-core-${var.name_suffix}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = var.key_vault_enabled_for_disk_encryption
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.key_vault_soft_delete_retention_days
  purge_protection_enabled    = var.key_vault_purge_protection_enabled

  sku_name = "standard"

  # network_acls {
  #   default_action = "Deny"
  #   bypass         = "AzureServices"
  #   ip_rules       = ["203.5.143.0/28", "203.5.137.64/27"]
  # }

  # Add the automation SPN for programmatic access via CICD
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions    = local.key_vault_key_permissions_full
    secret_permissions = local.key_vault_secret_permissions_full
  }

  # User Assigned Identity for Pod Identity
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.uai_principal_id

    key_permissions    = local.key_vault_key_permissions_full
    secret_permissions = local.key_vault_secret_permissions_full
  }

  # Add the list of additional groups that should have access to secrets
  dynamic "access_policy" {
    for_each = var.rbac_object_ids
    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value

      key_permissions    = local.key_vault_key_permissions_full
      secret_permissions = local.key_vault_secret_permissions_full
    }
  }
}
