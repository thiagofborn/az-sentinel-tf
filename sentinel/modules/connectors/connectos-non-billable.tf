
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.76.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-sentinel-rg"
    storage_account_name = "tfstatetlhzh"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg-sentinel" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "rg-sentinel" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.rg-sentinel.location
  resource_group_name = azurerm_resource_group.rg-sentinel.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
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

/* 
# Enabling Azure Active Directory. License dependent
resource "azurerm_sentinel_data_connector_azure_active_directory" "rg-sentinel" {
  name                       = "example-connector-azure-active-directory"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.rg-sentinel.id
}
*/

/*
# Enabling Cloud App Security
resource "azurerm_sentinel_data_connector_microsoft_cloud_app_security" "rg-sentinel" {
  name                       = "example-cloud-app-security"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.rg-sentinel.id
}
*/

/*
# Enabling Threat Intelligence - MISP or TAXII
resource "azurerm_sentinel_data_connector_threat_intelligence" "rg-sentinel" {
  name                       = "example-connector-threat-intelligence"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.rg-sentinel.id
}
*/

# Enabling Fusion
resource "azurerm_sentinel_alert_rule_fusion" "rg-sentinel" {
  name                       = "example-fusion-alert-rule"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.rg-sentinel.id
  alert_rule_template_guid   = "f71aba3d-28fb-450b-b192-4e76a83015c8"
}

# Enabling Security Center
resource "azurerm_sentinel_data_connector_azure_security_center" "rg-sentinel" {
  name                       = "example-security-center"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.rg-sentinel.id
}

