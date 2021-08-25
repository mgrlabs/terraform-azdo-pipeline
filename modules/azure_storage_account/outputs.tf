output "storage_account_name" {
  value       = azurerm_storage_account.acme.name
  description = "description"
}

output "storage_account_id" {
  value       = azurerm_storage_account.acme.id
  description = "description"
}

output "storage_account_primary_access_key" {
  value       = azurerm_storage_account.acme.primary_access_key
  sensitive   = true
  description = "description"
}

output "storage_account_primary_connection_string" {
  value       = azurerm_storage_account.acme.primary_connection_string
  sensitive   = true
  description = "description"
}

output "storage_account_primary_queue_endpoint" {
  value       = azurerm_storage_account.acme.primary_queue_endpoint
  sensitive   = true
  description = "description"
}
