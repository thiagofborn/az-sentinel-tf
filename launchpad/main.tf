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

resource "azurerm_resource_group" "tfstate-security" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.resource_tags
}

resource "azurerm_storage_account" "tfstate-security" {
  name                     = "tfstate-security${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfstate-security.name
  location                 = azurerm_resource_group.tfstate-security.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
  tags                     = var.resource_tags
}

resource "azurerm_storage_container" "tfstate-security" {
  name                  = var.azurerm_storage_container_name
  storage_account_name  = azurerm_storage_account.tfstate-security.name
  container_access_type = "blob"
}
