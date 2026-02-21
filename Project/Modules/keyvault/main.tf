data "azurerm_client_config" "current" {

}

resource "azurerm_key_vault" "kv" {
  name                        = "kv-finflow-${var.env}-${random_string.suffix.result}"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions         = ["Get", ]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
    certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover",
                               "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers",
                               "ListIssuers", "SetIssuers", "DeleteIssuers"]
  }
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

