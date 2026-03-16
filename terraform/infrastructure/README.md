# Terraform Infrastructure - Enterprise Endpoint Governance

This directory contains Terraform configuration for the supporting Azure infrastructure that powers the Enterprise Endpoint Governance Platform.

## 🏗️ Infrastructure Components

### Deployed Resources

1. **Resource Group** (`rg-intune-governance-dev`)
   - Logical container for all governance platform resources
   - Tagged for cost tracking and management

2. **Log Analytics Workspace** (`law-intune-gov-dev-{random}`)
   - Centralized monitoring for Intune policies
   - 30-day retention for compliance tracking
   - Integration point for Azure Monitor

3. **Storage Account** (`stintunegov{random}`)
   - Terraform state storage (tfstate container)
   - Compliance reports storage (compliance-reports container)
   - Policy backup storage (policy-backup container)
   - TLS 1.2 minimum, HTTPS-only access
   - 7-day soft delete protection

## 🚀 Quick Start

### Prerequisites

- Terraform >= 1.0 installed
- Azure CLI installed
- Azure Subscription (ID: 94609cbd-96c1-4f03-aeb9-3c8d7189c717)

### Installation

**1. Install Terraform**
```powershell
# Windows (via Chocolatey)
choco install terraform -y

# OR via Winget
winget install Hashicorp.Terraform

# Verify installation
terraform version
```

**2. Install Azure CLI**
```powershell
# Windows (via Winget)
winget install Microsoft.AzureCLI

# Verify installation
az --version
```

### Deployment

**1. Login to Azure**
```powershell
# Login via Azure CLI
az login

# Verify you're in the correct subscription
az account show

# Should show:
# "name": "Azure subscription 1"
# "id": "94609cbd-96c1-4f03-aeb9-3c8d7189c717"
```

**2. Initialize Terraform**
```powershell
# Navigate to this directory
cd terraform/infrastructure

# Initialize Terraform (downloads providers)
terraform init
```

**3. Preview Changes**
```powershell
# See what will be created
terraform plan

# Expected output:
# Plan: 6 to add, 0 to change, 0 to destroy
```

**4. Deploy Infrastructure**
```powershell
# Deploy the resources
terraform apply

# Type "yes" when prompted

# Expected output:
# Apply complete! Resources: 6 added, 0 changed, 0 destroyed
```

**5. View Outputs**
```powershell
# See what was created
terraform output

# Shows:
# - Resource Group name and ID
# - Log Analytics Workspace details
# - Storage Account details
# - Environment and location
```

## 📊 Environment Support

The configuration supports two environments:
- **dev** - Development environment (default)
- **prod** - Production environment

Set via the `environment` variable in `variables.tf`.

## 🔐 Authentication

This configuration uses **Azure CLI authentication** for simplicity:

- ✅ No service principal needed
- ✅ No secrets to manage
- ✅ Uses your `az login` session
- ✅ Perfect for learning and portfolio projects

For production CI/CD, you would:
1. Create a service principal
2. Store credentials in GitHub Secrets
3. Update provider to use service principal auth

## 📁 File Structure

```
terraform/infrastructure/
├── main.tf                    # Main Terraform configuration
├── variables.tf              # Variable definitions
├── outputs.tf                # Output values
├── terraform.tfvars.example  # Example variables
├── .gitignore               # Git ignore rules
└── README.md                # This file
```

## 🎯 What Gets Created

**Resource Group:**
- Name: `rg-intune-governance-dev`
- Location: UK South
- Tags: Environment, ManagedBy, Project, Owner

**Log Analytics Workspace:**
- Name: `law-intune-gov-dev-{random}`
- SKU: PerGB2018
- Retention: 30 days
- Purpose: Monitoring and compliance tracking

**Storage Account:**
- Name: `stintunegov{random}`
- Type: Standard LRS
- TLS: 1.2 minimum
- HTTPS only: Enabled
- Versioning: Enabled
- Soft delete: 7 days

**Storage Containers:**
1. `tfstate` - Terraform state files
2. `compliance-reports` - Compliance reporting data
3. `policy-backup` - Policy backups

## 💰 Cost Estimate

**Monthly costs (approximate):**
- Resource Group: £0
- Log Analytics Workspace: £1-2/month
- Storage Account: £0.50-1/month

**Total: ~£2-3/month**

## 🧹 Cleanup

To remove all resources:

```powershell
# Destroy all infrastructure
terraform destroy

# Type "yes" when prompted

# This will delete:
# - All storage containers
# - Storage account
# - Log Analytics Workspace
# - Resource Group
```

## 📚 Integration

### With PowerShell Module

The Intune governance platform uses PowerShell modules for policy deployment:
- **PowerShell** - Intune policy management via Graph API
- **Terraform** - Azure infrastructure provisioning

### With CI/CD Pipeline

While not yet implemented, future integration would include:
- GitHub Actions workflow for Terraform
- Automated infrastructure updates
- State management in Azure Storage

## 💡 Why Terraform for Infrastructure?

**Use Terraform for:**
- ✅ Azure infrastructure (Resource Groups, Storage, etc.)
- ✅ Consistent, repeatable deployments
- ✅ Infrastructure as Code best practices
- ✅ Version-controlled infrastructure changes

**Use PowerShell/Graph API for:**
- ✅ Intune policy management (Terraform provider has limited support)
- ✅ Complex Graph API interactions
- ✅ Custom automation workflows

## 🔄 State Management

**Current setup:**
- State stored locally in `.terraform` directory
- Not suitable for team collaboration

**Future enhancement:**
- Remote state in Azure Storage
- State locking for team safety
- Backend configuration in `main.tf`

## 🛠️ Troubleshooting

### Error: "Subscription not found"
- Verify: `az account show`
- Set correct subscription: `az account set --subscription "94609cbd-96c1-4f03-aeb9-3c8d7189c717"`

### Error: "Storage account name already exists"
- The random suffix ensures uniqueness
- If it fails, run `terraform apply` again

### Error: "Insufficient permissions"
- Verify you have Contributor access to the subscription
- Check with: `az role assignment list --assignee $(az account show --query user.name -o tsv)`

## 📖 Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

## 🎯 Portfolio Value

This Terraform implementation demonstrates:
- ✅ Infrastructure as Code expertise
- ✅ Azure resource provisioning
- ✅ Proper resource organization
- ✅ Security best practices (TLS 1.2, HTTPS-only)
- ✅ Cost optimization (Standard tier, LRS replication)
- ✅ Professional documentation

---

**Created by:** Taiwo Tee Awoniyi  
**Project:** Enterprise Endpoint Governance Platform  
**Repository:** github.com/TcSCloud/enterprise-endpoint-governance  
**Date:** March 2026
