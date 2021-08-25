output "sql_server_name" {
  value       = azurerm_mssql_server.acme.name
  description = "description"
}

output "sql_server_id" {
  value       = azurerm_mssql_server.acme.id
  description = "description"
}

output "sql_server_password" {
  value       = random_password.password.result
  sensitive   = true
  description = "description"
}
