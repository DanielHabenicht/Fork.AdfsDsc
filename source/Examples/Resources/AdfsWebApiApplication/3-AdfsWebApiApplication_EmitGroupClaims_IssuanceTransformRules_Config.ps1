<#PSScriptInfo
.VERSION 1.0.0
.GUID 9502c74f-40f5-4dbf-868d-bee77edc32a7
.AUTHOR DSC Community
.COMPANYNAME DSC Community
.COPYRIGHT (c) DSC Community. All rights reserved.
.TAGS DSCConfiguration
.LICENSEURI https://github.com/X-Guardian/AdfsDsc/blob/master/LICENSE
.PROJECTURI https://github.com/X-Guardian/AdfsDsc
.ICONURI https://dsccommunity.org/images/DSC_Logo_300p.png
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES Updated author and copyright notice.
.PRIVATEDATA 2016-Datacenter,2016-Datacenter-Server-Core
#>

#Requires -module AdfsDsc

<#
    .DESCRIPTION
        This configuration will add a Web API application with an Emit Group Claims Issuance Transform rule to an
        application group in Active Directory Federation Services (AD FS).
#>

Configuration AdfsWebApiApplication_EmitGroupClaims_IssuanceTransformRules_Config
{
    param()

    Import-DscResource -ModuleName AdfsDsc

    Node localhost
    {
        AdfsApplicationGroup AppGroup1
        {
            Name        = 'AppGroup1'
            Description = "This is the AppGroup1 Description"
        }

        AdfsWebApiApplication WebApiApp1
        {
            Name                          = 'AppGroup1 - Web API'
            ApplicationGroupIdentifier    = 'AppGroup1'
            Identifier                    = 'e7bfb303-c5f6-4028-a360-b6293d41338c'
            Description                   = 'App1 Web Api'
            AccessControlPolicyName       = 'Permit everyone'
            AlwaysRequireAuthentication   = $false
            AllowedClientTypes            = 'Public', 'Confidential'
            IssueOAuthRefreshTokensTo     = 'AllDevices'
            NotBeforeSkew                 = 0
            RefreshTokenProtectionEnabled = $true
            RequestMFAFromClaimsProviders = $false
            TokenLifetime                 = 0
            IssuanceTransformRules        = @(
                MSFT_AdfsIssuanceTransformRule
                {
                    TemplateName       = 'EmitGroupClaims'
                    Name               = 'App1 User Role Claim'
                    GroupName          = 'App1 Users'
                    OutgoingClaimType  = 'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'
                    OutgoingClaimValue = 'User'
                }
            )
        }
    }
}
