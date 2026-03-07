\# Enterprise Endpoint Governance Platform



> Automated endpoint governance for Microsoft Intune using Configuration as Code, PowerShell automation, and Microsoft Graph API



\[!\[Status](https://img.shields.io/badge/status-active%20development-green)]()

\[!\[Week](https://img.shields.io/badge/week-1%20complete-blue)]()

\[!\[License](https://img.shields.io/badge/license-MIT-green)]()



\## 🎯 Project Vision



Transform Microsoft Intune management from manual portal configuration to automated, version-controlled deployments using Configuration as Code principles. Enable enterprise-scale policy management with repeatable deployments, comprehensive testing, and full audit trails.



\## ✨ Key Features



\- ✅ \*\*Configuration as Code\*\* - JSON-based policy definitions with version control

\- ✅ \*\*PowerShell Automation\*\* - Custom module for Graph API deployment

\- ✅ \*\*Multi-Environment Support\*\* - Dev, test, and production configurations

\- ✅ \*\*Automated Validation\*\* - Pre-deployment configuration testing

\- ✅ \*\*Update Detection\*\* - Automatically update existing policies

\- 🔄 \*\*CI/CD Ready\*\* - GitHub Actions integration (coming soon)

\- 📊 \*\*Comprehensive Documentation\*\* - Architecture, deployment guides, and examples



\## 🏗️ Architecture

```

┌─────────────────────────────────────────────────────────┐

│              GitHub Repository (Version Control)         │

│  ┌─────────────┐  ┌──────────────┐  ┌───────────────┐  │

│  │ JSON        │  │ PowerShell   │  │ GitHub        │  │

│  │ Configs     │  │ Module       │  │ Actions       │  │

│  └─────────────┘  └──────────────┘  └───────────────┘  │

└──────────────────────┬──────────────────────────────────┘

&nbsp;                      │

&nbsp;        ┌─────────────▼──────────────┐

&nbsp;        │  Microsoft Graph API        │

&nbsp;        │  (Service Principal Auth)   │

&nbsp;        └─────────────┬───────────────┘

&nbsp;                      │

&nbsp;        ┌─────────────▼──────────────┐

&nbsp;        │     Microsoft Intune        │

&nbsp;        │  • Compliance Policies      │

&nbsp;        │  • Configuration Profiles   │

&nbsp;        │  • Applications             │

&nbsp;        └─────────────────────────────┘

```



\[See detailed architecture documentation](documentation/ARCHITECTURE.md)



\## 🚀 Quick Start



\### Prerequisites



\- PowerShell 7.0 or higher

\- Azure AD Service Principal with Intune permissions

\- GitHub account (for version control)



\### Installation

```powershell

\# Clone the repository

git clone https://github.com/TcSCloud/enterprise-endpoint-governance.git

cd enterprise-endpoint-governance



\# Import the module

Import-Module .\\modules\\IntuneAsCode\\IntuneAsCode.psm1 -Force

```



\### Basic Usage

```powershell

\# 1. Authenticate to Microsoft Graph

Connect-IntuneAsCode `

&nbsp;   -ClientId "YOUR\_CLIENT\_ID" `

&nbsp;   -ClientSecret "YOUR\_CLIENT\_SECRET" `

&nbsp;   -TenantId "YOUR\_TENANT\_ID"



\# 2. Validate a configuration

Test-IntuneConfigFile -ConfigPath ".\\configs\\compliance-policies\\corporate-baseline.json"



\# 3. Deploy a single policy

Deploy-IntuneCompliancePolicy -ConfigPath ".\\configs\\compliance-policies\\corporate-baseline.json"



\# 4. Deploy all policies in a folder

Deploy-IntuneConfigFolder -FolderPath ".\\configs\\compliance-policies"

```



\## 📁 Repository Structure

```

enterprise-endpoint-governance/

├── configs/                          # Configuration files

│   ├── compliance-policies/          # Compliance policy configs

│   │   ├── corporate-baseline.json   # ✅ Standard corporate policy

│   │   ├── secure-workstation.json   # ✅ Enhanced security (PAW)

│   │   ├── developer-workstation.json # ✅ Dev environment

│   │   ├── kiosk-shared-device.json  # ✅ Shared/kiosk devices

│   │   └── byod.json                 # ✅ BYOD policy

│   ├── configuration-profiles/       # Config profiles (future)

│   └── applications/                 # App deployments (future)

├── modules/

│   └── IntuneAsCode/                 # PowerShell automation module

│       ├── IntuneAsCode.psm1         # ✅ Module implementation

│       └── README.md                 # ✅ Module documentation

├── documentation/

│   ├── ARCHITECTURE.md               # ✅ Technical architecture

│   ├── PROJECT\_OVERVIEW.md           # Project vision and goals

│   └── DEPLOYMENT.md                 # Deployment guide (future)

├── .github/

│   └── workflows/                    # GitHub Actions (future)

├── archive/                          # Learning journey artifacts

│   └── terraform-exploration/        # Initial Terraform exploration

└── README.md                         # This file

```



\## 📊 Current Status



\*\*Project Timeline:\*\* 8 weeks (Started: February 8, 2026)  

\*\*Current Week:\*\* Week 1 ✅ COMPLETE  

\*\*Overall Progress:\*\* 15%



\### Week 1: Foundation \& Repository Setup ✅



\- \[x] GitHub repository created and configured

\- \[x] Azure service principal with API permissions

\- \[x] Custom PowerShell module (IntuneAsCode)

\- \[x] 5 compliance policy configurations

\- \[x] Architecture documentation

\- \[x] Module documentation

\- \[x] 3 successful production deployments



\### Upcoming Weeks



\- \*\*Week 2:\*\* Additional policy types and configurations

\- \*\*Week 3:\*\* CI/CD pipeline with GitHub Actions

\- \*\*Week 4:\*\* Monitoring, reporting, and dashboards

\- \*\*Week 5:\*\* Microsoft Purview integration (Information Protection)

\- \*\*Week 6:\*\* Advanced Purview (DLP, Insider Risk)

\- \*\*Week 7:\*\* Zero Trust implementation and auto-remediation

\- \*\*Week 8:\*\* Final documentation and portfolio presentation



\## 🎯 Project Goals



\### Business Value



\- ✅ Reduce policy deployment time by 90%

\- ✅ Achieve real-time compliance visibility (future)

\- ✅ Enable repeatable, consistent deployments

\- ✅ Implement automated remediation (future)

\- ✅ Demonstrate measurable ROI



\### Technical Objectives



\- ✅ 20+ production-ready configurations (5/20 complete)

\- 🔄 95%+ pipeline success rate (manual deployment currently)

\- 🔄 Full CI/CD automation (future)

\- 🔄 Comprehensive monitoring (future)

\- ✅ Professional code quality and documentation



\### Career Development



This project demonstrates:

\- ✅ Configuration as Code expertise

\- ✅ PowerShell module development

\- ✅ Microsoft Graph API mastery

\- ✅ Cloud architecture and automation

\- ✅ DevOps practices and tooling

\- ✅ Professional documentation



\## 🛠️ Technologies



\*\*Core Stack:\*\*

\- PowerShell 7.x

\- Microsoft Graph API

\- Azure AD (Service Principal Authentication)

\- Git/GitHub (Version Control)

\- JSON (Configuration Format)



\*\*Future Additions:\*\*

\- GitHub Actions (CI/CD)

\- Pester (Testing Framework)

\- Azure Monitor (Logging)

\- Power BI (Dashboards)



\## 📚 Documentation



\- \[Project Overview](documentation/PROJECT\_OVERVIEW.md) - Vision, goals, and success metrics

\- \[Architecture](documentation/ARCHITECTURE.md) - Technical design and decisions

\- \[Module Documentation](modules/IntuneAsCode/README.md) - PowerShell module guide

\- \[Deployment Guide](documentation/DEPLOYMENT.md) - Coming soon



\## 🔐 Security



\### Credentials Management



\- Service principal authentication

\- Secrets stored in GitHub Secrets

\- Regular credential rotation

\- No sensitive data in repository

\- `.gitignore` configured for secret files



\### Permissions Required



Azure AD Service Principal with:

\- `DeviceManagementConfiguration.ReadWrite.All`

\- `DeviceManagementManagedDevices.ReadWrite.All`

\- `DeviceManagementApps.ReadWrite.All`



\## 🚦 Deployment Status



\### Production Deployments



\*\*Total Policies Deployed:\*\* 3  

\*\*Success Rate:\*\* 100%  

\*\*Deployment Method:\*\* Manual (PowerShell module)



\*\*Live Policies:\*\*

1\. \*\*Basic Compliance\*\* - `5bf616c4-b97e-449f-bd44-92d174bae3f0`

2\. \*\*Corporate Baseline\*\* - `366deed4-8c0d-4ad3-aaed-b439602ad427`

3\. \*\*Secure Workstation\*\* - `f49df13b-0321-41d9-8504-5dcaff9e1eff`



\### Configuration Library



\*\*Available Configurations:\*\* 5

\- Corporate Baseline (deployed)

\- Secure Workstation (deployed)

\- Developer Workstation (ready)

\- Kiosk/Shared Device (ready)

\- BYOD (ready)



\## 💡 Examples



\### Example 1: Deploy Corporate Baseline

```powershell

\# Authenticate

Connect-IntuneAsCode -ClientId $env:CLIENT\_ID -ClientSecret $env:CLIENT\_SECRET -TenantId $env:TENANT\_ID



\# Deploy

Deploy-IntuneCompliancePolicy -ConfigPath ".\\configs\\compliance-policies\\corporate-baseline.json"

```



\### Example 2: Bulk Deploy All Policies

```powershell

\# Deploy all compliance policies

Deploy-IntuneConfigFolder -FolderPath ".\\configs\\compliance-policies"

```



\### Example 3: Test Before Deploying

```powershell

\# Validate configuration

Test-IntuneConfigFile -ConfigPath ".\\configs\\compliance-policies\\secure-workstation.json"



\# Preview deployment (WhatIf)

Deploy-IntuneCompliancePolicy -ConfigPath ".\\configs\\compliance-policies\\secure-workstation.json" -WhatIf



\# Deploy for real

Deploy-IntuneCompliancePolicy -ConfigPath ".\\configs\\compliance-policies\\secure-workstation.json"

```



\## 🤝 Contributing



This is a personal development project, but feedback and suggestions are welcome!



\## 👤 Author



\*\*Taiwo Tee Awoniyi\*\*  

Senior Systems Administrator | Infrastructure Engineer | Cloud Solution Consultant



\- 10+ years enterprise IT experience

\- Microsoft Certified: Azure Solutions Architect Expert

\- Specialized in Intune, Azure, OT environments

\- SC \& BPSS Security Cleared



\*\*Connect:\*\*

\- LinkedIn: \[linkedin.com/in/taiwot](https://linkedin.com/in/taiwot)

\- Email: back4good@yahoo.com

\- GitHub: \[github.com/TcSCloud](https://github.com/TcSCloud)



\## 📄 License



MIT License - See \[LICENSE](LICENSE) file for details



\## 🙏 Acknowledgments



\- Microsoft Graph API documentation

\- PowerShell community resources

\- DevOps best practices from the community



\## 📈 Project Metrics



\*\*Lines of Code:\*\* 400+  

\*\*Configurations:\*\* 5  

\*\*Deployments:\*\* 3 successful  

\*\*Documentation Pages:\*\* 4  

\*\*Time Invested:\*\* ~6 hours  

\*\*Career Impact:\*\* Significant



---



\*\*Status:\*\* Active Development  

\*\*Last Updated:\*\* February 9, 2026  

\*\*Version:\*\* 1.0  

\*\*Next Milestone:\*\* Week 2 - Additional configurations and GitHub Actions



---



⭐ \*\*Star this repo if you find it useful!\*\*

