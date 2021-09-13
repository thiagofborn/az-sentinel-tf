# From the Resource Group to Sentinel Hunting Queries
## Abstract

Templates to manage and deploy features on Azure Sentinel via Terraform.

## Prerequisites

- Azure user account with enough permissions to enable the required connectors. See table below for additional permissions. Write permissions to the workspace are **always** needed.
- Some data connectors also require a license to be present in order to be enabled. See table below.
- Threat Intelligence Platforms connector requires additional setup documented [here](https://docs.microsoft.com/azure/sentinel/connect-threat-intelligence#connect-azure-sentinel-to-your-threat-intelligence-platform)

The following table summarizes permissions, licenses and permissions. The cost is regarding the Log Analytics workspace use, for some of the connectors it is free:

| Data Connector                                 | License         |  Permissions                    | Cost      |
| ---------------------------------------------- | --------------- |---------------------------------|-----------|
| Azure Activity                                 | None            | Subscription Reader             | Free      |
| Azure Defender	                               | ASC Standard    | Security Reader                 | Free      |
| Azure Active Directory Identity Protection     | AAD Premium 2   | Global Admin or Security Admin  | Free      |
| Office 365                                     | None            | Global Admin or Security Admin  | Free      |
| Microsoft Cloud App Security                   | MCAS            | Global Admin or Security Admin  | Free      |
| Microsoft Defender for Identity                | AATP            | Global Admin or Security Admin  | Free      |
| Microsoft Defender for Endpoint                | MDATP           | Global Admin or Security Admin  | Free      |
| Azure Active Directory                         | Any AAD license | Global Admin or Security Admin  | Billed    |
| Threat Intelligence Platforms                  | None            | Global Admin or Security Admin  | Billed    |
| Security Events                                | None            | None                            | Billed    |
| Linux Syslog                                   | None            | None                            | Billed    |
| DNS (preview)                                  | None            | None                            | Billed    |
| Windows Firewall                               | None            | None                            | Billed    |
|                                                                                                                |

## Consideration about enabling Azure Active Directory Diagnostics

The recomendation to enable **Azure Active Directory Diagnostics** via **Azure Portal** or **Az CLI** using user login.

In order to enable **Azure Active Directory Diagnostics**, you must use a **user** login. This is a requirement to be able to manage the **Azure Active Directory Diagnostics Settings**. A **Service Principal** will not work even if you use **Owner Role** or **Global Admin** role assigned to it.

[Terraform Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_aad_diagnostic_setting) about **Azure Active Directory Diagnostics**.

## Log Analytics and Sentinel

The snippets below are for reference. The templates in the repository use features like **variables** to simplify future management.

```terraform
resource "azurerm_log_analytics_workspace" "rg-sentinel" {
  name                = "sentinel-tf-we-01"
  location            = azurerm_resource_group.rg-sentinel.location
  resource_group_name = azurerm_resource_group.rg-sentinel.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
    tags = {
    "Provisioner"     = "Terraform"
    "Security"        = "Sentinel"
  }
}

resource "azurerm_log_analytics_solution" "rg-sentinel" {
  solution_name         = "SecurityInsights"
  location              = azurerm_resource_group.rg-sentinel.location
  resource_group_name   = azurerm_resource_group.rg-sentinel.name
  workspace_resource_id = azurerm_log_analytics_workspace.rg-sentinel.id
  workspace_name        = azurerm_log_analytics_workspace.rg-sentinel.name
    tags = {
    "Provisioner"       = "Terraform"
    "Security"          = "Sentinel"
  }
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}
```
## Azure Sentinel non-billable (Free) Connectors 

1. [Azure Activity - Terraform sample](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_data_connector_azure_active_directory)
2. [Manages a Microsoft Defender Advanced Threat Protection Data Connector - Terraform sample](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_data_connector_microsoft_defender_advanced_threat_protection)
3. [Manages a Azure Advanced Threat Protection Data Connector - Terraform sample](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_data_connector_azure_advanced_threat_protection)
4. [Manages a Azure Security Center Data Connector - Terraform sample](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_data_connector_azure_security_center)
5. [Manages a Microsoft Cloud App Security Data Connector - Terraform sample](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_data_connector_microsoft_cloud_app_security)
7. [Manages a Office 365 Data Connector - Terraform sample](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_data_connector_office_365)

## Azure Sentinel Billable Connectors

1. [Manages a Threat Intelligence Data Connector - Terraform sample](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_data_connector_threat_intelligence)
2. [Manages a AWS CloudTrail Data Connector - Terraform sample](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_data_connector_aws_cloud_trail)


## Azure Sentinel Alerts

References to the _Terraform_ official documentation. 

1. [Manages a Sentinel Fusion Alert Rule - Terraform sample](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_alert_rule_fusion)
2. [Manages a Sentinel Machine Learning Behavior Analytics Alert Rule - Terraform sample](https://registry.terraform.io/providers/hashicorp/azurerm/docs/resources/sentinel_alert_rule_ms_security_incident)


## 

















