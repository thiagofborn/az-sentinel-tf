# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.76.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "storage-we-msdn-01"
    storage_account_name = "tfstatetw0bb"
    container_name       = "tfstate-security"
    key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-sentinel" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.resource_tags
}

resource "azurerm_log_analytics_workspace" "rg-sentinel" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.rg-sentinel.location
  resource_group_name = azurerm_resource_group.rg-sentinel.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.resource_tags
}

resource "azurerm_log_analytics_solution" "rg-sentinel" {
  solution_name         = "SecurityInsights"
  location              = azurerm_resource_group.rg-sentinel.location
  resource_group_name   = azurerm_resource_group.rg-sentinel.name
  workspace_resource_id = azurerm_log_analytics_workspace.rg-sentinel.id
  workspace_name        = azurerm_log_analytics_workspace.rg-sentinel.name
  tags                  = var.resource_tags

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}
