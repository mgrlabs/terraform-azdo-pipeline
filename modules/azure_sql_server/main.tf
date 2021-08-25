resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

data "azurerm_client_config" "current" {
}

locals {
  mssql_server_name = "sql-acme${var.environment}${local.location_abbr}${var.random_name_suffix}"
  location_abbr     = local.location_map[var.location]
  location_map = {
    australiaeast      = "aue"
    australiasoutheast = "aus"
  }
}

##################################
# MSSQL Server
##################################

resource "azurerm_mssql_server" "acme" {
  name                         = local.mssql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.mssql_version
  administrator_login          = var.mssql_administrator_login
  administrator_login_password = random_password.password.result
  minimum_tls_version          = var.mssql_minimum_tls_version

  azuread_administrator {
    login_username = var.esfx_service_principal_name
    object_id      = var.esfx_service_principal_object_id
    tenant_id      = data.azurerm_client_config.current.tenant_id
  }

  # extended_auditing_policy {
  #   storage_endpoint                        = azurerm_storage_account.example.primary_blob_endpoint
  #   storage_account_access_key              = azurerm_storage_account.example.primary_access_key
  #   storage_account_access_key_is_secondary = true
  #   retention_in_days                       = 6
  # }

  tags = var.tags
}

##################################
# MSSQL Database
##################################

resource "azurerm_mssql_database" "acme" {
  name      = var.mssql_database_name
  server_id = azurerm_mssql_server.acme.id
  collation = var.mssql_database_collation
  # license_type   = var.mssql_database_license_type
  max_size_gb = var.mssql_database_max_size_gb
  sku_name    = var.mssql_database_sku_name
  # zone_redundant = true

  # extended_auditing_policy {
  #   storage_endpoint                        = azurerm_storage_account.example.primary_blob_endpoint
  #   storage_account_access_key              = azurerm_storage_account.example.primary_access_key
  #   storage_account_access_key_is_secondary = true
  #   retention_in_days                       = 6
  # }
  tags = var.tags
}
