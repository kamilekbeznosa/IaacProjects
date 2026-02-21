output "redis_hostname" {
  value = azurerm_redis_cache.redis.hostname
}

output "redis_primary_key" {
  value     = azurerm_redis_cache.redis.primary_access_key
  sensitive = true
}

output "redis_ssl_port" {
  value = azurerm_redis_cache.redis.ssl_port
}