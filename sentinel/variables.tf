variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The name of the location for the Azure resources"
  default     = "West Europe"
}


variable "log_analytics_workspace_name" {
  type        = string
  default     = var.log_analytics_workspace_name
  description = "Log Analytics name used by Azure Sentinel"
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    environment = "staging"
    provisioner = "terraform"
    pipeline    = "GitHub Actions"
    team        = "security"
  }
}