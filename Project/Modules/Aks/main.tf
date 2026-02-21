resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-finflow-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-finflow-${var.env}"

  identity {
    type = "SystemAssigned"
    }

    default_node_pool {
        name = "systempool"

        vm_size = "Standard_B2s"
        auto_scaling_enabled = true
        min_count = 1
        max_count = 3
        vnet_subnet_id = var.subnet_id
}
    network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard"
      service_cidr = "172.16.0.0/16"
      dns_service_ip = "172.16.0.10"
    }
  ingress_application_gateway {
    gateway_id = var.agw_id
  }

  role_based_access_control_enabled = true
}

