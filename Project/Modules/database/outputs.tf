output "db_server_name" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "db_admin_login" {
  value = azurerm_postgresql_flexible_server.postgres.administrator_login
}

output "db_admin_password" {
  value     = azurerm_postgresql_flexible_server.postgres.administrator_password
  sensitive = true
}