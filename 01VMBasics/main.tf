variable "rg_name" {
  default = "rg-vm-basics"
}

variable "location" {
  default = "Poland Central"
}

variable "vm_size" {
  default = "Standard_B2s"
}

//ssh key generation
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_key_private" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/ssh_key.pem"
  file_permission = "0600"
}

//network
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-vm-basic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-vm-basic"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "pip-vm-basic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "watcher" {
  name                = "nw-vm-basic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {//allow ssh
    name                       = "AllowSSH"
    description                = "Allow SSH traffic"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 100
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    }

  security_rule {//python web traffic
    name = "AllowPythonWeb"
    description = "Allow Python Web traffic"
    priority = 1000
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "8080"
    source_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
  }
  
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-vm-basic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_watcher" {
  network_interface_id = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.watcher.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name = "linuxVM"
  size = var.vm_size
  network_interface_ids = [azurerm_network_interface.nic.id]
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  admin_username = "azureuser"

  admin_ssh_key {
    username = "azureuser"
    public_key = tls_private_key.ssh_key.public_key_openssh
    }
  
  os_disk {
  caching = "ReadWrite"
  storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
              #!/bin/bash
              echo "<h1>Hello from Terraform Automated VM!</h1>" > index.html
              echo "Server started at $(date)" >> index.html
              nohup python3 -m http.server 8080 &
              EOF
  )
}