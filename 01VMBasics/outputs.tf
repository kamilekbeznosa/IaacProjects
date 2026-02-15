output "vm_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "command" {
  value = "ssh -i ssh_key.pem azureuser@${azurerm_public_ip.pip.ip_address}"
}