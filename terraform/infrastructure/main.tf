# Enterprise Endpoint Governance Platform - Azure Infrastructure
# Managed via Terraform and GitHub Actions

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Configure Azure Provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  
  # Use Azure CLI authentication
  subscription_id = "94609cbd-96c1-4f03-aeb9-3c8d7189c717"
}

# Random suffix for globally unique resource names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Resource Group for Intune Governance Platform
resource "azurerm_resource_group" "intune_governance" {
  name     = "rg-intune-governance-${var.environment}"
  location = var.location
  
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Enterprise Endpoint Governance"
    Owner       = "Taiwo Tee Awoniyi"
    CostCenter  = "IT Infrastructure"
  }
}

# Log Analytics Workspace for Intune monitoring and compliance tracking
resource "azurerm_log_analytics_workspace" "intune_monitoring" {
  name                = "law-intune-gov-${var.environment}-${random_string.suffix.result}"
  location            = azurerm_resource_group.intune_governance.location
  resource_group_name = azurerm_resource_group.intune_governance.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  
  tags = {
    Environment = var.environment
    Purpose     = "Intune Policy Monitoring & Compliance Tracking"
    ManagedBy   = "Terraform"
  }
}

# Storage Account for Terraform state, logs, and compliance reports
resource "azurerm_storage_account" "governance_storage" {
  name                     = "stintunegov${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.intune_governance.name
  location                 = azurerm_resource_group.intune_governance.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Enable advanced security features
  enable_https_traffic_only = true
  min_tls_version          = "TLS1_2"
  
  blob_properties {
    versioning_enabled = true
    
    delete_retention_policy {
      days = 7
    }
  }
  
  tags = {
    Environment = var.environment
    Purpose     = "Terraform State & Compliance Reports"
    ManagedBy   = "Terraform"
  }
}

# Storage Container for Terraform state
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.governance_storage.name
  container_access_type = "private"
}

# Storage Container for compliance reports
resource "azurerm_storage_container" "compliance_reports" {
  name                  = "compliance-reports"
  storage_account_name  = azurerm_storage_account.governance_storage.name
  container_access_type = "private"
}

# Storage Container for policy backup
resource "azurerm_storage_container" "policy_backup" {
  name                  = "policy-backup"
  storage_account_name  = azurerm_storage_account.governance_storage.name
  container_access_type = "private"
}
