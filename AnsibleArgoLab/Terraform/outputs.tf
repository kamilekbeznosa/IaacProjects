output "vm_public_ips" {
  value = azurerm_public_ip.pip[*].ip_address
}

output "ssh_commands" {
  value = [
    for ip in azurerm_public_ip.pip[*].ip_address : 
    "ssh -i ssh_key.pem azureuser@${ip} -o StrictHostKeyChecking=no"
  ]
}