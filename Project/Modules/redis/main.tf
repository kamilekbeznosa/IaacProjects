resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_redis_cache" "redis" {
  name                = "redis-finflow-${var.env}-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 1
  family              = "C"
  
  sku_name            = "Standard" 
  
  non_ssl_port_enabled = false
  minimum_tls_version = "1.2"
  
  public_network_access_enabled = false

  redis_configuration {
  }
}

resource "azurerm_private_dns_zone" "redis_dns" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis_link" {
  name                  = "redis-link-${var.env}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.redis_dns.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_endpoint" "redis_pe" {
  name                = "pe-redis-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-redis"
    private_connection_resource_id = azurerm_redis_cache.redis.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }

  private_dns_zone_group {
    name                 = "redis-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.redis_dns.id]
  }
}