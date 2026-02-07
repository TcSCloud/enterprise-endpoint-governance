// ============================================================================
// INTUNE COMPLIANCE POLICY - WINDOWS 10/11 BASELINE
// ============================================================================
// Description: Enterprise-grade compliance policy for Windows 10/11 devices
// Author: Taiwo Tee Awoniyi
// Version: 1.0
// Last Updated: 2026-02-01
// ============================================================================

// PARAMETERS
// ============================================================================

@description('The display name for the compliance policy')
param policyName string = 'Windows 10/11 - Corporate Compliance Baseline'

@description('Policy description')
param policyDescription string = 'Baseline compliance requirements for all corporate Windows 10/11 devices'

@description('Minimum OS version required (e.g., 10.0.19041 for Windows 10 2004)')
param minimumOSVersion string = '10.0.19041'

@description('Require BitLocker encryption')
param requireBitLocker bool = true

@description('Require Secure Boot')
param requireSecureBoot bool = true

@description('Require TPM')
param requireTPM bool = true

@description('Minimum password length')
param minPasswordLength int = 12

@description('Password expiration in days (0 = never)')
param passwordExpirationDays int = 90

@description('Require antivirus (Defender)')
param requireAntivirus bool = true

@description('Require antispyware (Defender)')
param requireAntispyware bool = true

@description('Require firewall enabled')
param requireFirewall bool = true

@description('Maximum device threat level (Low, Medium, High, Secured, NotSet)')
@allowed([
  'Low'
  'Medium'
  'High'
  'Secured'
  'NotSet'
])
param deviceThreatProtectionLevel string = 'Medium'

@description('Days before compliance status expires')
param validityPeriodInDays int = 7

@description('Assignment group object IDs (comma-separated)')
param assignmentGroupIds array = []

// VARIABLES
// ============================================================================

var compliancePolicySettings = {
  '@odata.type': '#microsoft.graph.windows10CompliancePolicy'
  displayName: policyName
  description: policyDescription
  
  // OS Version Requirements
  osMinimumVersion: minimumOSVersion
  osMaximumVersion: null
  
  // BitLocker
  bitLockerEnabled: requireBitLocker
  
  // Secure Boot
  secureBootEnabled: requireSecureBoot
  
  // TPM
  tpmRequired: requireTPM
  
  // Code Integrity (Device Guard)
  codeIntegrityEnabled: false
  
  // Password Requirements
  passwordRequired: true
  passwordMinimumLength: minPasswordLength
  passwordRequiredType: 'deviceDefault'
  passwordMinutesOfInactivityBeforeLock: 15
  passwordExpirationDays: passwordExpirationDays
  passwordPreviousPasswordBlockCount: 5
  passwordRequireToUnlockFromIdle: true
  passwordBlockSimple: true
  
  // Security
  requireHealthyDeviceReport: true
  storageRequireEncryption: requireBitLocker
  
  // Defender
  antivirusRequired: requireAntivirus
  antispywareRequired: requireAntispyware
  defenderEnabled: true
  defenderVersion: null
  signatureOutOfDate: false
  rtpEnabled: true
  
  // Firewall
  firewallEnabled: requireFirewall
  
  // Device Threat Protection
  deviceThreatProtectionEnabled: true
  deviceThreatProtectionRequiredSecurityLevel: deviceThreatProtectionLevel
  
  // Mobile Threat Defense (if applicable)
  mobileOsMinimumVersion: null
  mobileOsMaximumVersion: null
  
  // Early Launch Anti-Malware
  earlyLaunchAntiMalwareDriverEnabled: true
  
  // Validity
  validOperatingSystemBuildRanges: []
  
  scheduledActionsForRule: [
    {
      ruleName: 'PasswordRequired'
      scheduledActionConfigurations: [
        {
          actionType: 'block'
          gracePeriodHours: 24
          notificationTemplateId: ''
          notificationMessageCCList: []
        }
      ]
    }
  ]
}

// RESOURCES
// ============================================================================

// Note: Bicep doesn't natively support Microsoft Graph resources yet
// This template serves as documentation and can be deployed via PowerShell/Graph API
// See deployment script: deploy-compliance-policy.ps1

// ============================================================================
// DEPLOYMENT SCRIPT REFERENCE
// ============================================================================
// To deploy this policy, use the accompanying PowerShell script:
//
// .\deploy-compliance-policy.ps1 -ParameterFile .\compliance-policy.parameters.json
//
// Or manually via Graph API:
// POST https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies
// ============================================================================

// OUTPUTS
// ============================================================================

output policyConfiguration object = compliancePolicySettings
output policyName string = policyName
output assignmentGroups array = assignmentGroupIds

// ============================================================================
// NOTES
// ============================================================================
// This compliance policy enforces:
// ✓ Minimum OS version
// ✓ BitLocker encryption
// ✓ Secure Boot
// ✓ TPM requirement
// ✓ Strong password requirements
// ✓ Windows Defender enabled and up-to-date
// ✓ Firewall enabled
// ✓ Device threat protection
//
// Recommended usage:
// 1. Create parameter file for each environment (dev, test, prod)
// 2. Test in dev environment first
// 3. Deploy via CI/CD pipeline
// 4. Monitor compliance dashboard
//
// Related policies:
// - Device configuration profiles
// - Conditional access policies
// - App protection policies
// ============================================================================
