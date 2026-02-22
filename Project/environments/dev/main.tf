provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-finglow-dev"
  location = "Poland Central"
}

module "Networking" {
  source = "../../Modules/Networking"

  env      = "dev"
  rg_name  = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location

  vnet_cidr    = var.vnet_cidr
  subnet_cidrs = var.subnet_cidrs
}

module "database" {
  source = "../../modules/database"

  env                 = "dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  subnet_id = module.Networking.snet_data_id
  vnet_id   = module.Networking.vnet_id
}

module "aks" {
  source = "../../Modules/Aks"

  env                 = "dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  agw_id              = module.agw.agw_id
  subnet_id = module.Networking.snet_aks_id
}

resource "azurerm_role_assignment" "aks_agic_contributor" {
  principal_id         = module.aks.ingress_identity_object_id
  role_definition_name             = "Contributor"
  scope                            = module.agw.agw_id
  skip_service_principal_aad_check = true
  
}

module "acr" {
  source = "../../modules/acr"

  env                 = "dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

module "keyvault" {
  source = "../../modules/keyvault"

  env                 = "dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = module.aks.kubelet_identity_object_id
  role_definition_name             = "AcrPull"
  scope                            = module.acr.acr_id
  skip_service_principal_aad_check = true

}

module "redis" {
  source = "../../modules/redis"

  env                 = "dev"
  resource_group_name = azurerm_resource_group.rg.name 
  location            = azurerm_resource_group.rg.location
  
  subnet_id           = module.Networking.snet_pe_id
  vnet_id             = module.Networking.vnet_id
}

module "agw" {
  source              = "../../Modules/agw"
  env                 = "dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.Networking.snet_agw_id
}

module "vpn" {
  source              = "../../Modules/vpn"
  env                 = "dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.Networking.snet_vpn_id
}