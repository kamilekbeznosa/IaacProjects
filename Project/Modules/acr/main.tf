resource "azurerm_container_registry" "acr" {
  name                = "acrfinflow${var.env}${random_string.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.env == "prod" ? "Premium" : "Basic"
  admin_enabled = false
}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
    special = false
}