---
title: IdentityCommand.SCA
subtitle: PowerShell for Idira Secure Cloud Access
hide_hero: true
---

<div class="has-text-centered mb-6">
  <img src="{{ '/SCA/media/images/IdentityCommand.SCA.png' | relative_url }}" alt="IdentityCommand.SCA" width="471">
</div>

**IdentityCommand.SCA** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the API for **CyberArk Secure Cloud Access** from within the PowerShell environment.

It builds on [IdentityCommand]({{ '/' | relative_url }}) for authentication - see [Getting Started]({{ '/SCA/getting-started/' | relative_url }}) to install and connect, and the [command reference]({{ '/SCA/commands/' | relative_url }}) for every command.

## User Access Policies

Policies grant identities just-in-time access to cloud roles. The parts of a policy are built with the `New-SCAPolicy*Definition` commands, each of which optionally accepts the output of a previous call so definitions can be chained:

```powershell
$Roles = New-SCAPolicyRoleDefinition -entityId 'arn:aws:iam::123451234567:role/examplerole' -entitySourceId '123451234567'
$Roles = New-SCAPolicyRoleDefinition -Definition $Roles -entityId 'arn:aws:iam::123451234567:role/otherrole' -entitySourceId '123451234567'

$Identities = New-SCAPolicyIdentityDefinition -entityName 'John.D@company.com' -entitySourceId 'A1B2C3D4-1AB2-465F-AB03-12345D55B05E' -entityClass user

$AccessRules = New-SCAPolicyAccessRuleDefinition -days Monday, Tuesday, Wednesday, Thursday, Friday -fromTime '08:00' -toTime '17:00' -maxSessionDuration 2 -timeZone 'Europe/London'

New-SCAPolicy -csp AWS -name finance -description 'End-of-year calculations' -roles $Roles -identities $Identities -accessRules $AccessRules
```

Policies can be listed, filtered, updated and removed:

```powershell
# All policies, or those matching a filter
Get-SCAPolicy
Get-SCAPolicy -status Active -cloud_provider AWS

# Update a single property - everything not supplied keeps its current value
Set-SCAPolicy -policy_id aws_7eb12345-e678-1a23-b5d5-12e39c1455fa -description 'Updated description'

# Archive a policy
Remove-SCAPolicy -policy_id aws_7eb12345-e678-1a23-b5d5-12e39c1455fa
```

Version 2.0 of the Policies API is used by every policy command.

## Requesting Access

List what you are eligible to access, then elevate:

```powershell
Get-SCAEligibleTarget -csp AWS

$Targets = New-SCAAccessTargetDefinition -workspaceId '123451234567' -roleName examplerole

Request-SCAAccess -csp AWS -organizationId '098765432109' -targets $Targets
```

Just-in-time membership of a cloud group can be requested in the same way:

```powershell
Get-SCAEligibleGroup

Request-SCAGroupMembership -directoryId 'abcde123-abcd-123a-abcd-a1b23456cd7e' -groupId '1234abcd-12ab-34cd-56ef-1234567890ab'
```

## Managing Sessions

```powershell
# Every active session in the tenant (requires the CS Admin role)
Get-SCASession

# Your own sessions
Get-SCASession -userId my

# Revoke by session, or every session belonging to a user
Revoke-SCASession -sessionIds '1234abcd-12ab-34cd-56ef-1234567890ab'
Revoke-SCASession -userId my
```

## Cloud Scans & Jobs

Scans, discoveries, policy changes and web app creation are asynchronous. `Get-SCAJobStatus` reports on the job:

```powershell
# Scan every onboarded AWS account
Start-SCAScan -cloudProvider AWS -accountType All | Get-SCAJobStatus

# Scan specific accounts only
$Entities = New-SCAScanEntityDefinition -org_id '098765432109' -account_id '123456789012'
Start-SCAScan -cloudProvider AWS -accountType Specific -entityIds $Entities

# Discover the structure of a newly added account, then scan it
Start-SCADiscovery -csp AWS -organization_id '123457654321' -id '987654123456' -new_account $true
```

## Onboarding & Approvals

```powershell
# Create the web app users connect to a cloud environment through
New-SCAWebApp -appType 'AWS IAM' -appName 'SA AWS Account 1234567890' -workspaceId '1234567890'

# Configure how on-demand access requests are approved
Get-SCAOnDemandConfig
Set-SCAOnDemandConfig -ApprovalChannel 'In-platform'
```

## Troubleshooting

Most SCA endpoints accept a `debug` parameter which returns extended detail alongside an API error. There is no module parameter for it - PowerShell reserves `-Debug` - so commands calling an endpoint which supports it send `debug=true` whenever they are run with the common `-Debug` parameter:

```powershell
Get-SCAPolicy -policy_id aws_7eb12345-e678-1a23-b5d5-12e39c1455fa -Debug
```

`Get-SCAModuleData` returns the module's session data, including details of the last command sent and the last error received:

```powershell
Get-SCAModuleData
```

