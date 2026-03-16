# Variables for Enterprise Endpoint Governance Infrastructure
# Using Azure CLI authentication - no service principal needed

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be either 'dev' or 'prod'."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "UK South"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "94609cbd-96c1-4f03-aeb9-3c8d7189c717"
}
