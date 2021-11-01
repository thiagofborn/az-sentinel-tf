variable "resource_group_name" {
  description = "The name of the resource group where the storage account will be deployed"
}

variable "location" {
  description = "The name of the region where the deploy will be made"
}

variable "azurerm_storage_container_name" {
  description = "The name of the storage container where the Terraform state will be saved"
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    environment = "staging"
    provisioner = "terraform"
    pipeline    = "GitHub Actions"
    team        = "security"
    recreation  = "1"
  }
}
