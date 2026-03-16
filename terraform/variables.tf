# Variables for Enterprise Endpoint Governance Infrastructure

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
  sensitive   = true

#}
#
#variable "client_id" {
 # description = "Azure Service Principal Client ID"
#  type        = string
 # sensitive   = true
#}

#variable "client_secret" {
#  description = "Azure Service Principal Client Secret"
 # type        = string
 # sensitive   = true
#}

#variable "tenant_id" {
#  description = "Azure Tenant ID"
#  type        = string
#  sensitive   = true
#}
