output "vnet_id" {
  value=azurerm_virtual_network.vnet.id
}

output "snet_data_id" {
  value = azurerm_subnet.snet_data.id
}

output "snet_vpn_id" {
  value = azurerm_subnet.snet_vpn.id
}

output "snet_aks_id" {
  value = azurerm_subnet.snet_aks.id
}

output "snet_pe_id" {
  value = azurerm_subnet.snet_pe.id
}

output "snet_agw_id" {
  value = azurerm_subnet.snet_agw.id
}