resource"random_password" "db_password" {
  length  = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_private_dns_zone" "pdns" {
  name                = "pdns-link-${var.env}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdns_link" {
  name                  = "pdns-${var.env}"
  private_dns_zone_name = azurerm_private_dns_zone.pdns.name
  virtual_network_id    = var.vnet_id
  resource_group_name = var.resource_group_name
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "psql-finflow-${var.env}"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "14"
  
  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.pdns.id
  public_network_access_enabled = false
  administrator_login          = "psqladmin"
  administrator_password = random_password.db_password.result
  sku_name = var.env == "prod" ? "B_Standard_B2ms" : "B_Standard_B1ms"
  storage_mb = 32768

  backup_retention_days = 7

  depends_on = [ azurerm_private_dns_zone_virtual_network_link.pdns_link ]
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}