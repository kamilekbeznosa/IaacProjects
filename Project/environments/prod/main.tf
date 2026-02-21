provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-finglow-dev"
  location = "Poland Central"
}

module "Networking" {
  source = "../../Modules/Networking"

  env = "dev"
  rg_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location

  vnet_cidr   = var.vnet_cidr
  subnet_cidrs = var.subnet_cidrs
}

module "database" {
  source = "../../modules/database"

  env                 = "dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  
  subnet_id           = module.networking.snet_data_id
  vnet_id             = module.networking.vnet_id
}