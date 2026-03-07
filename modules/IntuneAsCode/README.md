\# IntuneAsCode PowerShell Module



> Automated deployment of Microsoft Intune configurations using PowerShell and Microsoft Graph API



\## Overview



The IntuneAsCode module provides a complete automation framework for managing Microsoft Intune policies as code. It enables version-controlled, repeatable deployments of compliance policies, configuration profiles, and applications through JSON-based configurations.



\## Features



\- ✅ \*\*Authentication\*\* - Service principal authentication to Microsoft Graph

\- ✅ \*\*Compliance Policies\*\* - Deploy Windows 10/11 compliance policies

\- ✅ \*\*Bulk Deployment\*\* - Deploy multiple configurations from folders

\- ✅ \*\*Validation\*\* - Pre-deployment configuration validation

\- ✅ \*\*Update Detection\*\* - Automatically update existing policies

\- ✅ \*\*Error Handling\*\* - Comprehensive error reporting



\## Installation

```powershell

\# Import the module

Import-Module .\\modules\\IntuneAsCode\\IntuneAsCode.psm1 -Force



\# Verify installation

Get-Module IntuneAsCode

```



\## Quick Start



\### 1. Authenticate

```powershell

Connect-IntuneAsCode `

&nbsp;   -ClientId "YOUR\_CLIENT\_ID" `

&nbsp;   -ClientSecret "YOUR\_CLIENT\_SECRET" `

&nbsp;   -TenantId "YOUR\_TENANT\_ID"

```



\### 2. Deploy a Single Policy

```powershell

Deploy-IntuneCompliancePolicy -ConfigPath ".\\configs\\compliance-policies\\corporate-baseline.json"

```



\### 3. Deploy All Policies in a Folder

```powershell

Deploy-IntuneConfigFolder -FolderPath ".\\configs\\compliance-policies"

```



\### 4. Test Configuration (WhatIf)

```powershell

Deploy-IntuneCompliancePolicy -ConfigPath ".\\configs\\compliance-policies\\corporate-baseline.json" -WhatIf

```



\## Functions



\### Connect-IntuneAsCode



Authenticate to Microsoft Graph using service principal credentials.



\*\*Parameters:\*\*

\- `ClientId` - Azure AD Application Client ID

\- `ClientSecret` - Azure AD Application Client Secret

\- `TenantId` - Azure AD Tenant ID



\*\*Example:\*\*

```powershell

Connect-IntuneAsCode -ClientId "abc-123" -ClientSecret "secret" -TenantId "xyz-789"

```



---



\### Deploy-IntuneCompliancePolicy



Deploy a compliance policy from a JSON configuration file.



\*\*Parameters:\*\*

\- `ConfigPath` - Path to JSON configuration file

\- `WhatIf` - Preview deployment without applying changes



\*\*Example:\*\*

```powershell

Deploy-IntuneCompliancePolicy -ConfigPath ".\\corporate-baseline.json"

```



---



\### Deploy-IntuneConfigFolder



Deploy all configuration files from a folder.



\*\*Parameters:\*\*

\- `FolderPath` - Path to folder containing JSON configs

\- `WhatIf` - Preview deployment without applying changes



\*\*Example:\*\*

```powershell

Deploy-IntuneConfigFolder -FolderPath ".\\configs\\compliance-policies"

```



---



\### Get-IntuneCompliancePolicy



Retrieve existing compliance policy by display name.



\*\*Parameters:\*\*

\- `DisplayName` - Policy display name to search for



\*\*Example:\*\*

```powershell

Get-IntuneCompliancePolicy -DisplayName "Windows 10/11 - Corporate Baseline"

```



---



\### Test-IntuneConfigFile



Validate a JSON configuration file before deployment.



\*\*Parameters:\*\*

\- `ConfigPath` - Path to JSON configuration file



\*\*Example:\*\*

```powershell

Test-IntuneConfigFile -ConfigPath ".\\corporate-baseline.json"

```



\## Configuration File Format



JSON configuration files follow this structure:

```json

{

&nbsp; "metadata": {

&nbsp;   "name": "Policy Name",

&nbsp;   "description": "Policy description",

&nbsp;   "author": "Author Name",

&nbsp;   "version": "1.0",

&nbsp;   "lastModified": "2026-02-09",

&nbsp;   "environment": "all"

&nbsp; },

&nbsp; "policy": {

&nbsp;   "@odata.type": "#microsoft.graph.windows10CompliancePolicy",

&nbsp;   "displayName": "Windows 10/11 - Policy Name",

&nbsp;   "description": "Policy description for Intune",

&nbsp;   "osMinimumVersion": "10.0.19041",

&nbsp;   "passwordRequired": true,

&nbsp;   "passwordMinimumLength": 12

&nbsp;   // ... additional settings

&nbsp; }

}

```



\## Requirements



\- PowerShell 7.0 or higher

\- Azure AD Service Principal with permissions:

&nbsp; - `DeviceManagementConfiguration.ReadWrite.All`

&nbsp; - `DeviceManagementManagedDevices.ReadWrite.All`

&nbsp; - `DeviceManagementApps.ReadWrite.All`

\- Microsoft Graph API access



\## Best Practices



1\. \*\*Version Control\*\* - Store all JSON configs in Git

2\. \*\*Testing\*\* - Use `-WhatIf` before production deployments

3\. \*\*Validation\*\* - Run `Test-IntuneConfigFile` before deployment

4\. \*\*Authentication\*\* - Store credentials in GitHub Secrets or Azure Key Vault

5\. \*\*Naming\*\* - Use consistent naming: `environment-purpose-version.json`



\## Troubleshooting



\### Authentication Failed

```

Error: Authentication failed

```

\*\*Solution:\*\* Verify Client ID, Secret, and Tenant ID are correct.



\### Token Expired

```

Error: Token expired

```

\*\*Solution:\*\* Re-run `Connect-IntuneAsCode` to refresh the token.



\### Policy Already Exists

The module automatically detects and updates existing policies with the same display name.



\### Insufficient Permissions

```

Error: Insufficient privileges

```

\*\*Solution:\*\* Ensure service principal has required Graph API permissions with admin consent granted.



\## Examples



\### Example 1: Deploy Corporate Baseline

```powershell

\# Authenticate

Connect-IntuneAsCode -ClientId $env:CLIENT\_ID -ClientSecret $env:CLIENT\_SECRET -TenantId $env:TENANT\_ID



\# Deploy

Deploy-IntuneCompliancePolicy -ConfigPath ".\\configs\\compliance-policies\\corporate-baseline.json"

```



\### Example 2: Bulk Deploy with Validation

```powershell

\# Validate all configs

Get-ChildItem ".\\configs\\compliance-policies\\\*.json" | ForEach-Object {

&nbsp;   Test-IntuneConfigFile -ConfigPath $\_.FullName

}



\# Deploy all

Deploy-IntuneConfigFolder -FolderPath ".\\configs\\compliance-policies"

```



\### Example 3: WhatIf Analysis

```powershell

\# Preview changes without deploying

Deploy-IntuneCompliancePolicy -ConfigPath ".\\prod-policy.json" -WhatIf

```



\## Contributing



This module is part of the Enterprise Endpoint Governance Platform project.



Repository: https://github.com/TcSCloud/enterprise-endpoint-governance



\## Author



\*\*Taiwo Tee Awoniyi\*\*  

Senior Systems Administrator | Infrastructure Engineer



\## License



MIT License



\## Version History



\- \*\*1.0\*\* (2026-02-09) - Initial release

&nbsp; - Authentication function

&nbsp; - Compliance policy deployment

&nbsp; - Bulk deployment

&nbsp; - Validation functions

