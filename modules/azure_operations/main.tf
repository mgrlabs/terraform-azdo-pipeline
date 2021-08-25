locals {
  name_suffix   = "acme${var.environment}${local.location_abbr}${var.random_name_suffix}"
  location_abbr = local.location_map[var.location]
  location_map = {
    australiaeast      = "aue"
    australiasoutheast = "aus"
  }
  operations_roles = [
    "Log Analytics Contributor",
    "Application Insights Component Contributor"
  ]
  rbac_mappings = flatten([for role_name in local.operations_roles :
    [for object_id in var.rbac_object_ids : {
      role_name = role_name
      object_id = object_id
      }
    ]
  ])
}

##################################
# Log Analytics Workspace
##################################

resource "azurerm_log_analytics_workspace" "acme" {
  name                = "log-${local.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  retention_in_days   = var.log_analytics_workspace_retention
  sku                 = "PerGB2018"
  tags                = var.tags
}

# Role Assignment - Azure AD Object IDs
resource "azurerm_role_assignment" "log_analytics" {
  for_each = {
    for rbac_mapping in local.rbac_mappings : "${rbac_mapping.role_name}.${rbac_mapping.object_id}}" => rbac_mapping
  }
  scope                = azurerm_log_analytics_workspace.acme.id
  role_definition_name = each.value.role_name
  principal_id         = each.value.object_id
}

# Role Assignment - User Assigned Identity
resource "azurerm_role_assignment" "log_analytics_uai" {
  scope                = azurerm_log_analytics_workspace.acme.id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = var.uai_principal_id
}

##################################
# Application Insights
##################################

resource "azurerm_application_insights" "acme" {
  name                = "ai-${local.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "Node.JS"
  tags                = var.tags
}

# Role Assignment - Azure AD Object IDs
resource "azurerm_role_assignment" "application_insights" {
  for_each = {
    for rbac_mapping in local.rbac_mappings : "${rbac_mapping.role_name}.${rbac_mapping.object_id}}" => rbac_mapping
  }
  scope                = azurerm_application_insights.acme.id
  role_definition_name = each.value.role_name
  principal_id         = each.value.object_id
}

# Role Assignment - User Assigned Identity
resource "azurerm_role_assignment" "application_insights_uai" {
  scope                = azurerm_log_analytics_workspace.acme.id
  role_definition_name = "Application Insights Component Contributor"
  principal_id         = var.uai_principal_id
}

####################################
# SNOW Alerts - Application Insights
####################################

# Action Group - action group to send alerts notifications to
resource "azurerm_monitor_action_group" "acme" {
  name                = "ag-${local.name_suffix}"
  resource_group_name = var.resource_group_name
  short_name          = "ag-acme${var.environment}"

  webhook_receiver {
    name                    = "Splunk Webhook"
    service_uri             = var.splunk_hec_uri
    use_common_alert_schema = false
  }
}

# Azure monitor alert for P2 alert
resource "azurerm_monitor_scheduled_query_rules_alert" "ai_alert_1" {
  name                = "Alert_esfx${var.environment}_P2"
  location            = var.location
  resource_group_name = var.resource_group_name

  action {
    action_group = [azurerm_monitor_action_group.acme.id]
  }

  data_source_id = azurerm_application_insights.acme.id
  description    = "Alert when acme solution raises P2 error"
  enabled        = true

  query       = <<-QUERY
  traces
    | where severityLevel == 3 and customDimensions contains "P2-Alert"
  QUERY
  severity    = 1
  frequency   = 5
  time_window = 5
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }
}

# Azure monitor alert for P3 alert
resource "azurerm_monitor_scheduled_query_rules_alert" "ai_alert_2" {
  name                = "Alert_esfx${var.environment}_P3"
  location            = var.location
  resource_group_name = var.resource_group_name

  action {
    action_group = [azurerm_monitor_action_group.acme.id]
  }

  data_source_id = azurerm_application_insights.acme.id
  description    = "Alert when acme solution raises P3 error"
  enabled        = true

  query       = <<-QUERY
  traces
    | where severityLevel == 3 and customDimensions contains "P3-Alert"
  QUERY
  severity    = 2
  frequency   = 5
  time_window = 5
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }
}