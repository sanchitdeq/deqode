terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "59d6d9a0-07dd-44b2-a16d-4ae044731549"
  client_id = "1cc5d673-cbcb-4ff4-8c5c-b04229110de5"
  client_secret = "Hbt8Q~R9.Fl2_1hemVfLeG1mLNhm3Ig.K5QoxcmJ"
  tenant_id = "5550d1de-8067-40b6-8406-b77e569206a1"
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
  
}

resource "azurerm_resource_group" "tfstate" {
  name     = "tfstate"
  location = "East US"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
