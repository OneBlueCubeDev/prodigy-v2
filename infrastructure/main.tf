
#############################################################################
# PROVIDERS
#############################################################################

terraform {
  backend "azurerm"{    
        resource_group_name   = "tfstaterg"
        storage_account_name  = "tfstatef3c1"
        container_name        = "tfstate"
        key                   = "terraform_workshop.tfstate"
  }
}   

#### Providers #####
provider "azurerm" {
   features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "random" {

}

### Data ####
data "azurerm_client_config" "current" {}

#### Resources #####
resource "random_string" "sa_name" {
  length = 4
  special = false
  upper = false
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgName
  location = var.region

  tags = {
    environment = "uat"
    project = "prodigy"
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = var.storageName 
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "uat"
    project = "prodigy"
  }

}

#keyvault resources
resource "azurerm_key_vault" "prodigykv" {
  name                        = "prodigykeyvault"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  tags = {
    environment = "uat"
    project = "prodigy"
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

  # keyvault  Access Policy
resource "azurerm_key_vault_access_policy" "prodigyapp" {
  key_vault_id = "${azurerm_key_vault.prodigykv.id}"
  tenant_id    = "${data.azurerm_client_config.current.tenant_id}"

  object_id = "${azurerm_app_service.prodigy-asp.identity.0.principal_id}"

  secret_permissions = [
    "get",
  ]
}

