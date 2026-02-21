terraform {
  backend "azurerm" {
    resource_group_name = "rg-terraform-state"
    container_name = "tfstate"
    storage_account_name = "tfstatefinflow30469"
    key="dev.finflow.tfstate"
  }
}