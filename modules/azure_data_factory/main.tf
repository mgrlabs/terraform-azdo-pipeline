locals {
  data_factory_roles = [
    "Data Factory Contributor"
  ]
  rbac_mappings = flatten([for role_name in local.data_factory_roles :
    [for object_id in var.rbac_object_ids : {
      role_name = role_name
      object_id = object_id
      }
    ]
  ])
}

resource "azurerm_data_factory" "module" {
  name                = var.data_factory_name
  resource_group_name = var.resource_group_name
  location            = var.location
  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      vsts_configuration
    ]
  }

  tags = var.tags
}

##################################
# Role Assignments
##################################

resource "azurerm_role_assignment" "rbac_mappings" {
  for_each = {
    for rbac_mapping in local.rbac_mappings : "${rbac_mapping.role_name}.${rbac_mapping.object_id}}" => rbac_mapping
  }
  scope                = azurerm_data_factory.module.id
  role_definition_name = each.value.role_name
  principal_id         = each.value.object_id
}

resource "azurerm_role_assignment" "rbac_mappings_uai" {
  for_each             = toset(local.data_factory_roles)
  scope                = azurerm_data_factory.module.id
  role_definition_name = each.key
  principal_id         = var.uai_principal_id
}


#############################################
# LOGS
#############################################

# resource "azurerm_monitor_diagnostic_setting" "adf_logs" {
#   name                       = "LOG-MERCH-FPEO-ADF-${var.environment}-AUE"
#   target_resource_id         = azurerm_data_factory.adf.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id
#   log_analytics_destination_type  = "Dedicated"

#   log {
#     category = "ActivityRuns"
#   }
#   log {
#     category = "PipelineRuns"
#   }
#   log {
#     category = "TriggerRuns"
#   }

#   metric {
#     category = "AllMetrics"
#   }
# }