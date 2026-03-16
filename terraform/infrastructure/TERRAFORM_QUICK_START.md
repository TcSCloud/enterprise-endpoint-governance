# 🚀 TERRAFORM DEPLOYMENT - QUICK START GUIDE

## 📥 STEP 1: Download All 6 Files (2 mins)

Download these files from above:
1. main.tf
2. variables.tf
3. outputs.tf
4. terraform.tfvars.example
5. .gitignore
6. README.md

## 📁 STEP 2: Save to Correct Location (1 min)

Save all 6 files to:
```
D:\CloudProject\IntunePack\Taiwot.com\Dev\enterprise-endpoint-governance\terraform\infrastructure\
```

**Replace any existing files!**

## ⚙️ STEP 3: Install Azure CLI (if not already installed) (3 mins)

```powershell
# Install Azure CLI
winget install Microsoft.AzureCLI

# Restart PowerShell after installation

# Verify installation
az --version
```

## 🔐 STEP 4: Login to Azure (2 mins)

```powershell
# Login to Azure
az login

# When browser opens, login with:
# nvrnet_aol.com@taiwotee.onmicrosoft.com

# Verify you're in the correct subscription
az account show

# Should show:
# "name": "Azure subscription 1"
# "id": "94609cbd-96c1-4f03-aeb9-3c8d7189c717"
```

## 🚀 STEP 5: Deploy Terraform! (10 mins)

```powershell
# Navigate to Terraform directory
cd D:\CloudProject\IntunePack\Taiwot.com\Dev\enterprise-endpoint-governance\terraform\infrastructure

# Initialize Terraform (downloads providers)
terraform init

# Expected output:
# "Terraform has been successfully initialized!"
# "Installing hashicorp/azurerm v3.x.x..."
# "Installing hashicorp/random v3.x.x..."

# Preview what will be created
terraform plan

# Expected output:
# "Plan: 6 to add, 0 to change, 0 to destroy"

# Deploy the infrastructure!
terraform apply

# Type "yes" when prompted

# Expected output:
# "Apply complete! Resources: 6 added, 0 changed, 0 destroyed"
# Plus output values showing resource names
```

## ✅ STEP 6: Verify in Azure Portal (2 mins)

1. Go to: https://portal.azure.com
2. Search for "Resource Groups"
3. You should see: **rg-intune-governance-dev**
4. Click on it to see:
   - Log Analytics Workspace (law-intune-gov-dev-XXXXXX)
   - Storage Account (stintunegovXXXXXX)

**Screenshot this!** 📸

## 📊 STEP 7: View Terraform Outputs (1 min)

```powershell
# See what was created
terraform output

# Expected output:
# environment = "dev"
# location = "UK South"
# resource_group_name = "rg-intune-governance-dev"
# storage_account_name = "stintunegovXXXXXX"
# log_analytics_workspace_name = "law-intune-gov-dev-XXXXXX"
# etc.
```

**Screenshot this too!** 📸

## 💾 STEP 8: Commit to Git (5 mins)

```powershell
cd D:\CloudProject\IntunePack\Taiwot.com\Dev\enterprise-endpoint-governance

# Check status
git status

# Add Terraform files
git add terraform/

# Commit
git commit -m "feat: Add Terraform infrastructure for Azure resources

- Resource Group for governance platform
- Log Analytics Workspace for monitoring
- Storage Account with 3 containers
- Deployed successfully to Azure subscription
- Using Azure CLI authentication"

# Push to dev branch
git push origin dev
```

## 🎉 DONE!

You now have:
- ✅ Terraform infrastructure deployed to Azure
- ✅ 6 resources created (1 RG, 1 LAW, 1 Storage, 3 Containers)
- ✅ Code committed to GitHub
- ✅ Screenshots for portfolio
- ✅ Terraform skill demonstrated!

## 💰 COST

**Monthly cost:** ~£2-3
- Log Analytics: ~£1-2/month
- Storage Account: ~£0.50-1/month

## 🧹 TO DESTROY LATER (Optional)

```powershell
cd D:\CloudProject\IntunePack\Taiwot.com\Dev\enterprise-endpoint-governance\terraform\infrastructure

# Destroy all resources
terraform destroy

# Type "yes" when prompted

# This removes everything and costs you nothing!
```

---

## 🎯 TOTAL TIME: ~25 minutes

**Then you're 100% DONE with Terraform!** 🚀

---

## 📸 PORTFOLIO SCREENSHOTS TO TAKE:

1. **Azure Portal** - Resource Group showing all resources
2. **Terraform output** - Command line showing deployment success
3. **GitHub repo** - terraform/ folder committed
4. **Azure Portal** - Storage Account showing containers

---

## 💪 FOR INTERVIEWS:

> "I use Terraform to provision Azure infrastructure for my Intune governance platform. I deployed Resource Groups, Log Analytics for monitoring, and Storage Accounts using Terraform with proper security controls including TLS 1.2 enforcement and HTTPS-only access. The infrastructure is version-controlled and uses Infrastructure as Code best practices."

**Interviewer:** ✅💰

---

**Questions? Stuck somewhere? Let me know!** 

**Otherwise - download the 6 files and DEPLOY!** 🔥
