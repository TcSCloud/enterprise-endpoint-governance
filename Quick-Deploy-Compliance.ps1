param(
    [Parameter(Mandatory=$true)]
    [string]$ClientId,
    
    [Parameter(Mandatory=$true)]
    [string]$ClientSecret,
    
    [Parameter(Mandatory=$true)]
    [string]$TenantId
)

# Authenticate to Graph
Write-Host "?? Authenticating to Microsoft Graph..." -ForegroundColor Cyan
$body = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $ClientId
    Client_Secret = $ClientSecret
}

$response = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Method POST -Body $body
$token = $response.access_token

if (-not $token) {
    Write-Host "? Authentication failed!" -ForegroundColor Red
    exit 1
}

Write-Host "? Authenticated successfully!" -ForegroundColor Green

# SIMPLIFIED compliance policy (works with basic Intune licensing)
$compliancePolicy = @{
    "@odata.type" = "#microsoft.graph.windows10CompliancePolicy"
    displayName = "Windows 10/11 - Basic Compliance (IaC Deployed)"
    description = "Basic compliance policy deployed via Infrastructure as Code - GitHub Repository"
    
    # OS Requirements (Basic)
    osMinimumVersion = "10.0.19041"
    
    # Password Requirements (Basic)
    passwordRequired = $true
    passwordBlockSimple = $true
    passwordMinimumLength = 8
    passwordMinutesOfInactivityBeforeLock = 15
    
    # Security (Basic)
    storageRequireEncryption = $false
    
    # Scheduled Actions
    scheduledActionsForRule = @(
        @{
            ruleName = "PasswordRequired"
            scheduledActionConfigurations = @(
                @{
                    actionType = "block"
                    gracePeriodHours = 24
                }
            )
        }
    )
} | ConvertTo-Json -Depth 10

# Deploy to Intune
Write-Host "?? Deploying basic compliance policy to Intune..." -ForegroundColor Cyan

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$uri = "https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies"

try {
    $result = Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body $compliancePolicy
    
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "? POLICY DEPLOYED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Policy Name: $($result.displayName)" -ForegroundColor Cyan
    Write-Host "Policy ID: $($result.id)" -ForegroundColor Cyan
    Write-Host "Created: $($result.createdDateTime)" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Green
    
    Write-Host "?? View in Intune Portal:" -ForegroundColor Yellow
    Write-Host "https://endpoint.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesComplianceMenu/~/policies" -ForegroundColor Cyan
    
    # Save policy details
    @{
        PolicyId = $result.id
        PolicyName = $result.displayName
        DeployedAt = Get-Date
        DeployedBy = "Infrastructure as Code"
    } | ConvertTo-Json | Out-File -FilePath ".\deployed-policy-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    
} catch {
    Write-Host "? Deployment failed!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.BaseStream.Position = 0
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response: $responseBody" -ForegroundColor Yellow
    }
    exit 1
}

Write-Host "`n?? SUCCESS! Your first Infrastructure as Code deployment to Intune!" -ForegroundColor Green
Write-Host "? Policy is live in your Intune environment" -ForegroundColor Green