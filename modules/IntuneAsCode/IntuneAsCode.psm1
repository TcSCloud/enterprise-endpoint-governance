<#
.SYNOPSIS
    Intune as Code PowerShell Module
.DESCRIPTION
    Deployment automation for Microsoft Intune using Configuration as Code
.AUTHOR
    Taiwo Tee Awoniyi
.VERSION
    1.1 - Fixed error handling
#>

#Requires -Version 7.0

# ============================================================================
# AUTHENTICATION FUNCTIONS
# ============================================================================

function Connect-IntuneAsCode {
    <#
    .SYNOPSIS
        Authenticate to Microsoft Graph for Intune management
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ClientId,
        
        [Parameter(Mandatory = $true)]
        [string]$ClientSecret,
        
        [Parameter(Mandatory = $true)]
        [string]$TenantId
    )
    
    Write-Host "?? Authenticating to Microsoft Graph..." -ForegroundColor Cyan
    
    $body = @{
        Grant_Type    = "client_credentials"
        Scope         = "https://graph.microsoft.com/.default"
        Client_Id     = $ClientId
        Client_Secret = $ClientSecret
    }
    
    try {
        $response = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Method POST -Body $body
        
        $script:AuthToken = $response.access_token
        $script:TokenExpiry = (Get-Date).AddSeconds($response.expires_in)
        
        Write-Host "? Authentication successful!" -ForegroundColor Green
        Write-Host "   Token expires: $script:TokenExpiry" -ForegroundColor Gray
        
        return $true
    }
    catch {
        Write-Host "? Authentication failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Get-IntuneAuthHeaders {
    <#
    .SYNOPSIS
        Get authentication headers for Graph API calls
    #>
    
    if (-not $script:AuthToken) {
        throw "Not authenticated. Run Connect-IntuneAsCode first."
    }
    
    if ((Get-Date) -gt $script:TokenExpiry) {
        throw "Token expired. Please re-authenticate."
    }
    
    return @{
        "Authorization" = "Bearer $script:AuthToken"
        "Content-Type"  = "application/json"
    }
}

# ============================================================================
# COMPLIANCE POLICY FUNCTIONS
# ============================================================================

function Deploy-IntuneCompliancePolicy {
    <#
    .SYNOPSIS
        Deploy compliance policy from JSON configuration
    .EXAMPLE
        Deploy-IntuneCompliancePolicy -ConfigPath ".\configs\compliance-policies\corporate-baseline.json"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigPath,
        
        [Parameter(Mandatory = $false)]
        [switch]$WhatIf
    )
    
    # Load configuration
    if (-not (Test-Path $ConfigPath)) {
        Write-Host "? Config file not found: $ConfigPath" -ForegroundColor Red
        return $false
    }
    
    $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
    $policyName = $config.policy.displayName
    
    Write-Host "?? Processing: $policyName" -ForegroundColor Cyan
    Write-Host "   Config: $ConfigPath" -ForegroundColor Gray
    
    # Check if policy exists
    $existingPolicy = Get-IntuneCompliancePolicy -DisplayName $policyName
    
    if ($WhatIf) {
        if ($existingPolicy) {
            Write-Host "   WHATIF: Would UPDATE existing policy" -ForegroundColor Yellow
        }
        else {
            Write-Host "   WHATIF: Would CREATE new policy" -ForegroundColor Yellow
        }
        Write-Host "   Policy config:" -ForegroundColor Gray
        $config.policy | ConvertTo-Json -Depth 10
        return $true
    }
    
    # Deploy
    try {
        $headers = Get-IntuneAuthHeaders
        $uri = "https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies"
        $body = $config.policy | ConvertTo-Json -Depth 10
        
        if ($existingPolicy) {
            Write-Host "?? Updating existing policy..." -ForegroundColor Yellow
            $uri = "$uri/$($existingPolicy.id)"
            $result = Invoke-RestMethod -Uri $uri -Headers $headers -Method Patch -Body $body
        }
        else {
            Write-Host "?? Creating new policy..." -ForegroundColor Green
            $result = Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body $body
        }
        
        Write-Host "? SUCCESS: Policy deployed" -ForegroundColor Green
        Write-Host "   Policy ID: $($result.id)" -ForegroundColor Cyan
        Write-Host "   Created: $($result.createdDateTime)" -ForegroundColor Gray
        
        return $result
    }
    catch {
        Write-Host "? Deployment failed: $($_.Exception.Message)" -ForegroundColor Red
        
        # FIXED: Better error handling for API responses
        if ($_.ErrorDetails.Message) {
            Write-Host "   API Error Details:" -ForegroundColor Yellow
            try {
                $errorObj = $_.ErrorDetails.Message | ConvertFrom-Json
                Write-Host "   Error Code: $($errorObj.error.code)" -ForegroundColor Yellow
                Write-Host "   Message: $($errorObj.error.message)" -ForegroundColor Yellow
            }
            catch {
                Write-Host "   $($_.ErrorDetails.Message)" -ForegroundColor Yellow
            }
        }
        
        return $false
    }
}

function Get-IntuneCompliancePolicy {
    <#
    .SYNOPSIS
        Get existing compliance policy by display name
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$DisplayName
    )
    
    try {
        $headers = Get-IntuneAuthHeaders
        $uri = "https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies"
        
        $result = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
        
        return $result.value | Where-Object { $_.displayName -eq $DisplayName }
    }
    catch {
        Write-Host "??  Error checking existing policies: $($_.Exception.Message)" -ForegroundColor Yellow
        return $null
    }
}

# ============================================================================
# BULK DEPLOYMENT FUNCTIONS
# ============================================================================

function Deploy-IntuneConfigFolder {
    <#
    .SYNOPSIS
        Deploy all configurations from a folder
    .EXAMPLE
        Deploy-IntuneConfigFolder -FolderPath ".\configs\compliance-policies"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FolderPath,
        
        [Parameter(Mandatory = $false)]
        [switch]$WhatIf
    )
    
    if (-not (Test-Path $FolderPath)) {
        Write-Host "? Folder not found: $FolderPath" -ForegroundColor Red
        return
    }
    
    $configs = Get-ChildItem -Path $FolderPath -Filter "*.json" -Recurse
    
    Write-Host "?? Found $($configs.Count) configuration file(s)" -ForegroundColor Cyan
    Write-Host ""
    
    $results = @()
    
    foreach ($config in $configs) {
        Write-Host "????????????????????????????????????????" -ForegroundColor Gray
        
        $result = Deploy-IntuneCompliancePolicy -ConfigPath $config.FullName -WhatIf:$WhatIf
        
        $results += @{
            Config  = $config.Name
            Success = ($null -ne $result -and $result -ne $false)
            Result  = $result
        }
        
        Write-Host ""
    }
    
    Write-Host "????????????????????????????????????????" -ForegroundColor Gray
    Write-Host "?? DEPLOYMENT SUMMARY" -ForegroundColor Cyan
    Write-Host "   Total: $($results.Count)" -ForegroundColor White
    Write-Host "   Success: $($results.Where({$_.Success}).Count)" -ForegroundColor Green
    Write-Host "   Failed: $($results.Where({-not $_.Success}).Count)" -ForegroundColor Red
    
    return $results
}

# ============================================================================
# VALIDATION FUNCTIONS
# ============================================================================

function Test-IntuneConfigFile {
    <#
    .SYNOPSIS
        Validate JSON configuration file
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigPath
    )
    
    Write-Host "?? Validating: $ConfigPath" -ForegroundColor Cyan
    
    # Check file exists
    if (-not (Test-Path $ConfigPath)) {
        Write-Host "? File not found" -ForegroundColor Red
        return $false
    }
    
    # Check valid JSON
    try {
        $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
        Write-Host "? Valid JSON" -ForegroundColor Green
    }
    catch {
        Write-Host "? Invalid JSON: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    
    # Check required fields
    if (-not $config.policy.'@odata.type') {
        Write-Host "? Missing @odata.type" -ForegroundColor Red
        return $false
    }
    
    if (-not $config.policy.displayName) {
        Write-Host "? Missing displayName" -ForegroundColor Red
        return $false
    }
    
    Write-Host "? Configuration valid" -ForegroundColor Green
    return $true
}

# ============================================================================
# EXPORT FUNCTIONS
# ============================================================================

Export-ModuleMember -Function @(
    'Connect-IntuneAsCode',
    'Deploy-IntuneCompliancePolicy',
    'Deploy-IntuneConfigFolder',
    'Get-IntuneCompliancePolicy',
    'Test-IntuneConfigFile'
)
