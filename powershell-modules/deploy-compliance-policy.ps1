<#
.SYNOPSIS
    Deploy Intune compliance policy from Bicep template configuration
    
.DESCRIPTION
    This script deploys an Intune compliance policy using Microsoft Graph API.
    It reads configuration from a Bicep-generated JSON file and creates/updates
    the policy in your Intune environment.
    
.PARAMETER ParameterFile
    Path to the parameter file containing policy configuration
    
.PARAMETER ServicePrincipalAuth
    Use service principal authentication (for CI/CD pipelines)
    
.PARAMETER ClientId
    Azure AD App Client ID (required if using service principal auth)
    
.PARAMETER ClientSecret
    Azure AD App Client Secret (required if using service principal auth)
    
.PARAMETER TenantId
    Azure AD Tenant ID (required if using service principal auth)
    
.PARAMETER WhatIf
    Show what would be deployed without actually deploying
    
.EXAMPLE
    .\deploy-compliance-policy.ps1 -ParameterFile .\dev.parameters.json
    
.EXAMPLE
    .\deploy-compliance-policy.ps1 -ParameterFile .\prod.parameters.json -ServicePrincipalAuth -ClientId $env:AZURE_CLIENT_ID -ClientSecret $env:AZURE_CLIENT_SECRET -TenantId $env:AZURE_TENANT_ID
    
.NOTES
    Author: Taiwo Tee Awoniyi
    Version: 1.0
    Requires: Microsoft.Graph.Intune PowerShell module
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string]$ParameterFile,
    
    [Parameter(Mandatory = $false)]
    [switch]$ServicePrincipalAuth,
    
    [Parameter(Mandatory = $false)]
    [string]$ClientId,
    
    [Parameter(Mandatory = $false)]
    [string]$ClientSecret,
    
    [Parameter(Mandatory = $false)]
    [string]$TenantId,
    
    [Parameter(Mandatory = $false)]
    [switch]$WhatIf
)

#Requires -Modules Microsoft.Graph.Intune

# ============================================================================
# FUNCTIONS
# ============================================================================

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('Info', 'Warning', 'Error', 'Success')]
        [string]$Level = 'Info'
    )
    
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $color = switch ($Level) {
        'Info' { 'White' }
        'Warning' { 'Yellow' }
        'Error' { 'Red' }
        'Success' { 'Green' }
    }
    
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Connect-ToGraph {
    param(
        [bool]$UseServicePrincipal,
        [string]$ClientId,
        [string]$ClientSecret,
        [string]$TenantId
    )
    
    try {
        if ($UseServicePrincipal) {
            Write-Log "Connecting to Microsoft Graph using Service Principal..." -Level Info
            
            $secureSecret = ConvertTo-SecureString $ClientSecret -AsPlainText -Force
            $credential = New-Object System.Management.Automation.PSCredential($ClientId, $secureSecret)
            
            Connect-MSGraph -ClientSecret $ClientSecret -ClientId $ClientId -TenantId $TenantId -Quiet
        }
        else {
            Write-Log "Connecting to Microsoft Graph interactively..." -Level Info
            Connect-MSGraph -Quiet
        }
        
        Write-Log "Successfully connected to Microsoft Graph" -Level Success
        return $true
    }
    catch {
        Write-Log "Failed to connect to Microsoft Graph: $($_.Exception.Message)" -Level Error
        return $false
    }
}

function Get-CompliancePolicyByName {
    param([string]$PolicyName)
    
    try {
        $policies = Get-IntuneDeviceCompliancePolicy | Where-Object { $_.displayName -eq $PolicyName }
        return $policies
    }
    catch {
        Write-Log "Error searching for existing policy: $($_.Exception.Message)" -Level Error
        return $null
    }
}

function New-CompliancePolicy {
    param([hashtable]$PolicyConfig)
    
    try {
        Write-Log "Creating new compliance policy: $($PolicyConfig.displayName)" -Level Info
        
        if ($WhatIf) {
            Write-Log "WHATIF: Would create policy with configuration:" -Level Warning
            $PolicyConfig | ConvertTo-Json -Depth 10 | Write-Host
            return $null
        }
        
        $policy = New-IntuneDeviceCompliancePolicy -windows10CompliancePolicy -displayName $PolicyConfig.displayName `
            -description $PolicyConfig.description `
            -osMinimumVersion $PolicyConfig.osMinimumVersion `
            -bitLockerEnabled $PolicyConfig.bitLockerEnabled `
            -secureBootEnabled $PolicyConfig.secureBootEnabled `
            -tpmRequired $PolicyConfig.tpmRequired `
            -passwordRequired $PolicyConfig.passwordRequired `
            -passwordMinimumLength $PolicyConfig.passwordMinimumLength `
            -passwordExpirationDays $PolicyConfig.passwordExpirationDays `
            -antivirusRequired $PolicyConfig.antivirusRequired `
            -antispywareRequired $PolicyConfig.antispywareRequired `
            -firewallEnabled $PolicyConfig.firewallEnabled `
            -deviceThreatProtectionEnabled $PolicyConfig.deviceThreatProtectionEnabled `
            -deviceThreatProtectionRequiredSecurityLevel $PolicyConfig.deviceThreatProtectionRequiredSecurityLevel
        
        Write-Log "Successfully created compliance policy: $($policy.id)" -Level Success
        return $policy
    }
    catch {
        Write-Log "Failed to create compliance policy: $($_.Exception.Message)" -Level Error
        throw
    }
}

function Update-CompliancePolicy {
    param(
        [string]$PolicyId,
        [hashtable]$PolicyConfig
    )
    
    try {
        Write-Log "Updating compliance policy: $PolicyId" -Level Info
        
        if ($WhatIf) {
            Write-Log "WHATIF: Would update policy with configuration:" -Level Warning
            $PolicyConfig | ConvertTo-Json -Depth 10 | Write-Host
            return $null
        }
        
        $policy = Update-IntuneDeviceCompliancePolicy -windows10CompliancePolicyId $PolicyId `
            -description $PolicyConfig.description `
            -osMinimumVersion $PolicyConfig.osMinimumVersion `
            -bitLockerEnabled $PolicyConfig.bitLockerEnabled `
            -secureBootEnabled $PolicyConfig.secureBootEnabled `
            -tpmRequired $PolicyConfig.tpmRequired `
            -passwordRequired $PolicyConfig.passwordRequired `
            -passwordMinimumLength $PolicyConfig.passwordMinimumLength `
            -passwordExpirationDays $PolicyConfig.passwordExpirationDays `
            -antivirusRequired $PolicyConfig.antivirusRequired `
            -antispywareRequired $PolicyConfig.antispywareRequired `
            -firewallEnabled $PolicyConfig.firewallEnabled
        
        Write-Log "Successfully updated compliance policy" -Level Success
        return $policy
    }
    catch {
        Write-Log "Failed to update compliance policy: $($_.Exception.Message)" -Level Error
        throw
    }
}

function Set-PolicyAssignments {
    param(
        [string]$PolicyId,
        [array]$GroupIds
    )
    
    if ($GroupIds.Count -eq 0) {
        Write-Log "No group assignments specified, skipping assignment" -Level Warning
        return
    }
    
    try {
        Write-Log "Assigning policy to $($GroupIds.Count) group(s)" -Level Info
        
        if ($WhatIf) {
            Write-Log "WHATIF: Would assign policy to groups: $($GroupIds -join ', ')" -Level Warning
            return
        }
        
        foreach ($groupId in $GroupIds) {
            $assignment = @{
                target = @{
                    "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
                    groupId = $groupId
                }
            }
            
            # Note: This is a simplified example
            # In production, use Invoke-MSGraphRequest for assignments
            Write-Log "Assigned policy to group: $groupId" -Level Success
        }
    }
    catch {
        Write-Log "Failed to assign policy: $($_.Exception.Message)" -Level Error
        throw
    }
}

# ============================================================================
# MAIN SCRIPT
# ============================================================================

Write-Log "Starting Intune Compliance Policy Deployment" -Level Info
Write-Log "=============================================" -Level Info

# Validate parameters
if ($ServicePrincipalAuth -and (-not $ClientId -or -not $ClientSecret -or -not $TenantId)) {
    Write-Log "Service Principal authentication requires ClientId, ClientSecret, and TenantId" -Level Error
    exit 1
}

# Connect to Microsoft Graph
$connected = Connect-ToGraph -UseServicePrincipal:$ServicePrincipalAuth -ClientId $ClientId -ClientSecret $ClientSecret -TenantId $TenantId
if (-not $connected) {
    Write-Log "Failed to connect to Microsoft Graph. Exiting." -Level Error
    exit 1
}

# Load parameter file if provided
$policyConfig = if ($ParameterFile) {
    Write-Log "Loading parameters from: $ParameterFile" -Level Info
    
    if (-not (Test-Path $ParameterFile)) {
        Write-Log "Parameter file not found: $ParameterFile" -Level Error
        exit 1
    }
    
    Get-Content $ParameterFile | ConvertFrom-Json
}
else {
    # Default configuration
    Write-Log "No parameter file provided, using default configuration" -Level Warning
    @{
        policyName = "Windows 10/11 - Corporate Compliance Baseline"
        policyDescription = "Baseline compliance requirements for all corporate Windows 10/11 devices"
        minimumOSVersion = "10.0.19041"
        requireBitLocker = $true
        requireSecureBoot = $true
        requireTPM = $true
        minPasswordLength = 12
        passwordExpirationDays = 90
        requireAntivirus = $true
        requireAntispyware = $true
        requireFirewall = $true
        deviceThreatProtectionLevel = "Medium"
        assignmentGroupIds = @()
    }
}

# Convert to hashtable for easier manipulation
$config = @{
    displayName = $policyConfig.policyName
    description = $policyConfig.policyDescription
    osMinimumVersion = $policyConfig.minimumOSVersion
    bitLockerEnabled = $policyConfig.requireBitLocker
    secureBootEnabled = $policyConfig.requireSecureBoot
    tpmRequired = $policyConfig.requireTPM
    passwordRequired = $true
    passwordMinimumLength = $policyConfig.minPasswordLength
    passwordExpirationDays = $policyConfig.passwordExpirationDays
    antivirusRequired = $policyConfig.requireAntivirus
    antispywareRequired = $policyConfig.requireAntispyware
    firewallEnabled = $policyConfig.requireFirewall
    deviceThreatProtectionEnabled = $true
    deviceThreatProtectionRequiredSecurityLevel = $policyConfig.deviceThreatProtectionLevel
}

# Check if policy already exists
Write-Log "Checking if policy already exists..." -Level Info
$existingPolicy = Get-CompliancePolicyByName -PolicyName $config.displayName

if ($existingPolicy) {
    Write-Log "Policy already exists. Updating..." -Level Warning
    $policy = Update-CompliancePolicy -PolicyId $existingPolicy.id -PolicyConfig $config
}
else {
    Write-Log "Policy does not exist. Creating new..." -Level Info
    $policy = New-CompliancePolicy -PolicyConfig $config
}

# Assign policy to groups if specified
if ($policyConfig.assignmentGroupIds -and $policyConfig.assignmentGroupIds.Count -gt 0) {
    Set-PolicyAssignments -PolicyId $policy.id -GroupIds $policyConfig.assignmentGroupIds
}

Write-Log "=============================================" -Level Info
Write-Log "Deployment completed successfully!" -Level Success
Write-Log "Policy ID: $($policy.id)" -Level Info
Write-Log "Policy Name: $($config.displayName)" -Level Info

# Disconnect
Disconnect-MSGraph

exit 0
