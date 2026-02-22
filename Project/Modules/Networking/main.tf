resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.env}"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.rg_name
}

//application gateway
resource "azurerm_subnet" "snet_agw" {
  name="snet-agw"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.subnet_cidrs["agw"]]
}

//AKS
resource "azurerm_subnet" "snet_aks" {
  name="snet-aks"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.subnet_cidrs["aks"]]
}

//data
resource "azurerm_subnet" "snet_data" {
  name="snet-data"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.subnet_cidrs["data"]]

  delegation {
    name = "delegation-data"
    service_delegation {
        name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }

  private_endpoint_network_policies = "Enabled"
}

//VPN
resource "azurerm_subnet" "snet_vpn" {
  name="GatewaySubnet"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.subnet_cidrs["vpn"]]
}

resource "azurerm_subnet" "snet_pe" {
  name="snet-pe"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.subnet_cidrs["pe"]]
}
