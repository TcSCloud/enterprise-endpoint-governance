# Outputs for Enterprise Endpoint Governance Infrastructure

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.intune_governance.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.intune_governance.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.intune_monitoring.name
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.intune_monitoring.id
  sensitive   = true
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.governance_storage.name
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.governance_storage.primary_blob_endpoint
}

output "tfstate_container_name" {
  description = "Name of the Terraform state container"
  value       = azurerm_storage_container.tfstate.name
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "location" {
  description = "Azure region"
  value       = var.location
}
