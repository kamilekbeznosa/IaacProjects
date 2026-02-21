resource "azurerm_public_ip" "agw_pip" {
  name                = "pip-agw-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "agw" {
  name                = "agw-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "agw-ip-config"
    subnet_id = var.subnet_id 
  }

  frontend_port {
    name = "fe-port-80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "fe-ip-config"
    public_ip_address_id = azurerm_public_ip.agw_pip.id
  }

  backend_address_pool {
    name = "be-pool"
  }

  backend_http_settings {
    name                  = "be-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
  }

  http_listener {
    name                           = "listener-80"
    frontend_ip_configuration_name = "fe-ip-config"
    frontend_port_name             = "fe-port-80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "listener-80"
    backend_address_pool_name  = "be-pool"
    backend_http_settings_name = "be-http-settings"
    priority                   = 100
  }
}