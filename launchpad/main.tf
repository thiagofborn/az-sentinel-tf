terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.76.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate_securitry" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.resource_tags
}

resource "azurerm_storage_account" "tfstate_securitry" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfstate_securitry.name
  location                 = azurerm_resource_group.tfstate_securitry.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
  tags                     = var.resource_tags
}

resource "azurerm_storage_container" "tfstate_securitry" {
  name                  = var.azurerm_storage_container_name
  storage_account_name  = azurerm_storage_account.tfstate_securitry.name
  container_access_type = "blob"
}
