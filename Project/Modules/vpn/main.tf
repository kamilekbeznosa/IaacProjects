resource "azurerm_public_ip" "vpn_pip" {
  name                = "pip-vpn-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vpn_gw" {
  name                = "vpngw-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name

  type = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp = false

  sku = "VpnGw1"

  ip_configuration {
    name                          = "vpngw-ip-config"
    public_ip_address_id          = azurerm_public_ip.vpn_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  vpn_client_configuration {
    address_space = ["172.168.200.0/24"]
    root_certificate {
        name = "root-cert"
        public_cert_data = "MIIC7zCCAdegAwIBAgIQfPB7NFulWJ9PJwAGMXuZkTANBgkqhkiG9w0BAQsFADAaMRgwFgYDVQQDDA9GaW5nbG93Um9vdENlcnQwHhcNMjYwMjIyMTQzNTU2WhcNMjcwMjIyMTQ1NTU2WjAaMRgwFgYDVQQDDA9GaW5nbG93Um9vdENlcnQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC9sFRg2oO15g7WtVmGUyRqdZEqUnnJ9cFmO7/BhEvPfuLwjKepzwE1aTMA/+NRGSGAuJxoGLXvtBj38jriusjQU1Xy7x3Jh6nGpQysDaQeEAC3ZW5byZo64eRPmI+8EcpQ7ZEqmPDUXEzUKwnxczVH1I5hw9VvVfrtMAaZLj12iWUM27M/4U3nDTQYNrS3JJHUU2Pf3wy9rGmZKRtN5gYKiy1vYPWb1bRX61u/EjIUx4XqvVVfqlvK2CIvru0LFVxigro1W4MKFIWPetj092vIFvNhT+ZKQe+gaE2Y+3bfq1EPmTyZWbSmhbivu75x61PQImw6cNNXMlScc6UW5LT1AgMBAAGjMTAvMA4GA1UdDwEB/wQEAwICBDAdBgNVHQ4EFgQUvJGcUHWKIXnVArUofiLMGQ5wvk0wDQYJKoZIhvcNAQELBQADggEBAFO0Mmk3S9hRDB6eVUY88gKmZrvlR/9o4ErwsIKMh+5RS+DKOBqA2rt/dUxoukjSSf7RGVasx7i6DCMjD287oPR6DMMy0PURB6B2jFnZ3HRf1oVH6YJM6iIfehj0f12KhmUCfkmjtUEUfTNP9wMCx8IJjEJJ1/tQULZABqQJjzQfwbhIYxJOqmvowSLoOWM8BCaXjoxQwInhIhxM/tGaB55td0BV/pQrchGU1KQbP/yP9VniOi8Ykf+Tm0hSvmdcWy2bVuxtmcX2Bmmat0cPho+qz2DCMBFHMMwvdCBap74Y+o3JCELwq0FkPT6LbXImzVInTCakm9wZDYIi+LZ0Td4="
    }
  }
}