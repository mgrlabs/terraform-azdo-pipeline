##################################
# Outputs
##################################

# Application Insights
output "app_insights_key" {
  value       = azurerm_application_insights.acme.instrumentation_key
  sensitive   = true
  description = "The Instrumentation Key for this Application Insights component."
}

output "app_insights_connection_string" {
  value       = azurerm_application_insights.acme.connection_string
  sensitive   = true
  description = "The Connection String for this Application Insights component. (Sensitive)."
}

# Log Analytics Workspace
output "log_analytics_primary_shared_key" {
  value       = azurerm_log_analytics_workspace.acme.primary_shared_key
  sensitive   = true
  description = "The Primary shared key for the Log Analytics Workspace."
}

output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.acme.workspace_id
  sensitive   = true
  description = "The Workspace (or Customer) ID for the Log Analytics Workspace."
}
