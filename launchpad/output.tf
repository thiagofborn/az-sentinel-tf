output "azurerm_resource_group" {
  value       = azurerm_resource_group.tfstate.name
  sensitive   = false
  description = "The name of the resource group where the storage account will be deployed"
}

output "azurerm_storage_account" {
  value       = azurerm_storage_account.tfstate.name
  sensitive   = false
  description = "The storage account to save the Terraform State"
}

output "azurerm_storage_container" {
  value       = azurerm_storage_container.tfstate.name
  sensitive   = false
  description = "The name of the storage container where the Terraform state will be saved"
}