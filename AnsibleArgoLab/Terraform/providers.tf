terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.60.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
}

