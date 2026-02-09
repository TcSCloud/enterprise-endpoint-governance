# ============================================================================
# Create Intune VM Always-On Power Management Policy (CORRECTED)
# ============================================================================
# Purpose: Create Settings Catalog policy for VM always-on power settings
# Author: Taiwo
# Note: Uses correct ChoiceSetting format for power timeout settings
# ============================================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$PolicyName = 'Global-Endpoint-VMs-AlwaysOn',
    
    [Parameter(Mandatory = $false)]
    [switch]$WhatIf
)

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
        'Info'    { 'Cyan' }
        'Warning' { 'Yellow' }
        'Error'   { 'Red' }
        'Success' { 'Green' }
    }
    
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

# ============================================================================
# MAIN SCRIPT
# ============================================================================

try {
    Write-Log "========================================" -Level Info
    Write-Log "Intune VM Always-On Power Policy Creation" -Level Info
    Write-Log "========================================" -Level Info
    
    # Check if already connected
    $context = Get-MgContext
    if (-not $context) {
        Write-Log "Connecting to Microsoft Graph..." -Level Info
        Connect-MgGraph -Scopes "DeviceManagementConfiguration.ReadWrite.All" -NoWelcome
        $context = Get-MgContext
    }
    
    Write-Log "Connected to tenant: $($context.TenantId)" -Level Success
    Write-Log "Authenticated as: $($context.Account)" -Level Success
    
    # ========================================================================
    # Create Settings Catalog policy with CORRECT ChoiceSetting format
    # ========================================================================
    
    Write-Log "Creating Settings Catalog policy: $PolicyName" -Level Info
    
    $policyDescription = "Power management policy for Intune-managed VMs. Prevents sleep, hibernation, and display timeout to ensure VMs remain always-on for lab/testing purposes. Created via PowerShell script."
    
    # Settings Catalog JSON definition - CORRECTED with ChoiceSettingValue
    $settingsCatalogPolicy = @{
        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationPolicy'
        name = $PolicyName
        description = $policyDescription
        platforms = 'windows10'
        technologies = 'mdm'
        settings = @(
            # Display timeout plugged in (Never = 0)
            @{
                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    settingDefinitionId = 'device_vendor_msft_policy_config_power_displayofftimeoutpluggedin'
                    choiceSettingValue = @{
                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                        value = 'device_vendor_msft_policy_config_power_displayofftimeoutpluggedin_0'
                        children = @()
                    }
                }
            },
            # Display timeout on battery (Never = 0)
            @{
                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    settingDefinitionId = 'device_vendor_msft_policy_config_power_displayofftimeoutonbattery'
                    choiceSettingValue = @{
                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                        value = 'device_vendor_msft_policy_config_power_displayofftimeoutonbattery_0'
                        children = @()
                    }
                }
            },
            # Standby timeout plugged in (Never = 0)
            @{
                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    settingDefinitionId = 'device_vendor_msft_policy_config_power_standbytimeoutpluggedin'
                    choiceSettingValue = @{
                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                        value = 'device_vendor_msft_policy_config_power_standbytimeoutpluggedin_0'
                        children = @()
                    }
                }
            },
            # Standby timeout on battery (Never = 0)
            @{
                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    settingDefinitionId = 'device_vendor_msft_policy_config_power_standbytimeoutonbattery'
                    choiceSettingValue = @{
                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                        value = 'device_vendor_msft_policy_config_power_standbytimeoutonbattery_0'
                        children = @()
                    }
                }
            },
            # Hibernate timeout plugged in (Never = 0)
            @{
                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    settingDefinitionId = 'device_vendor_msft_policy_config_power_hibernatetimeoutpluggedin'
                    choiceSettingValue = @{
                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                        value = 'device_vendor_msft_policy_config_power_hibernatetimeoutpluggedin_0'
                        children = @()
                    }
                }
            },
            # Hibernate timeout on battery (Never = 0)
            @{
                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    settingDefinitionId = 'device_vendor_msft_policy_config_power_hibernatetimeoutonbattery'
                    choiceSettingValue = @{
                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                        value = 'device_vendor_msft_policy_config_power_hibernatetimeoutonbattery_0'
                        children = @()
                    }
                }
            }
        )
    } | ConvertTo-Json -Depth 10
    
    # Check if policy already exists
    $uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"
    $existingPolicies = Invoke-MgGraphRequest -Method GET -Uri $uri
    $existingPolicy = $existingPolicies.value | Where-Object { $_.name -eq $PolicyName }
    
    if ($existingPolicy) {
        Write-Log "Policy '$PolicyName' already exists (ID: $($existingPolicy.id))" -Level Warning
        $policyId = $existingPolicy.id
        
        if ($WhatIf) {
            Write-Log "[WHATIF] Would update existing policy" -Level Warning
        }
        else {
            Write-Log "Updating existing policy..." -Level Info
            $updateUri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$policyId"
            Invoke-MgGraphRequest -Method PATCH -Uri $updateUri -Body $settingsCatalogPolicy -ContentType 'application/json'
            Write-Log "Policy updated successfully" -Level Success
        }
    }
    else {
        if ($WhatIf) {
            Write-Log "[WHATIF] Would create policy: $PolicyName" -Level Warning
            $policyId = "00000000-0000-0000-0000-000000000000"
        }
        else {
            Write-Log "Creating new policy: $PolicyName" -Level Info
            $response = Invoke-MgGraphRequest -Method POST -Uri $uri -Body $settingsCatalogPolicy -ContentType 'application/json'
            $policyId = $response.id
            Write-Log "Policy created successfully (ID: $policyId)" -Level Success
        }
    }
    
    # ========================================================================
    # COMPLETION SUMMARY
    # ========================================================================
    
    Write-Log "========================================" -Level Success
    Write-Log "Policy Creation Summary" -Level Success
    Write-Log "========================================" -Level Success
    Write-Log "Policy Name: $PolicyName" -Level Info
    Write-Log "Policy ID: $policyId" -Level Info
    Write-Log "========================================" -Level Success
    
    Write-Log "" -Level Info
    Write-Log "Power Settings Configured:" -Level Info
    Write-Log "  - Display timeout (AC/DC): Never (0)" -Level Info
    Write-Log "  - Sleep timeout (AC/DC): Never (0)" -Level Info
    Write-Log "  - Hibernate timeout (AC/DC): Never (0)" -Level Info
    Write-Log "" -Level Info
    Write-Log "Next Steps:" -Level Info
    Write-Log "1. Go to Microsoft Endpoint Manager portal" -Level Info
    Write-Log "2. Navigate to: Devices > Configuration profiles" -Level Info
    Write-Log "3. Find policy: $PolicyName" -Level Info
    Write-Log "4. Click Assignments > Add group" -Level Info
    Write-Log "5. Select your 'Virtual Machines' group" -Level Info
    Write-Log "6. Save the assignment" -Level Info
    Write-Log "" -Level Info
    
    if (-not $WhatIf) {
        Write-Log "Policy created successfully!" -Level Success
        Write-Log "Assign it manually in the Intune portal" -Level Success
    }
    else {
        Write-Log "WhatIf mode - no changes were made" -Level Warning
    }
}
catch {
    Write-Log "Policy creation failed: $($_.Exception.Message)" -Level Error
    
    # Show more detailed error if available
    if ($_.ErrorDetails) {
        Write-Log "Error details: $($_.ErrorDetails.Message)" -Level Error
    }
    
    Write-Log "Stack trace: $($_.ScriptStackTrace)" -Level Error
    throw
}
finally {
    # Disconnect from Microsoft Graph
    if (Get-MgContext) {
        Disconnect-MgGraph | Out-Null
        Write-Log "Disconnected from Microsoft Graph" -Level Info
    }
}
