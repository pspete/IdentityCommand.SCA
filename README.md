![Logo][Logo]

[Logo]: /docs/media/images/IdentityCommand.SCA.png

# IdentityCommand.SCA

**IdentityCommand.SCA** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the API for **CyberArk Secure Cloud Access** from within the PowerShell environment.

| Main Branch              | Latest Build             | CodeFactor                 | Coverage                     | PowerShell Gallery        | License                      |
| ------------------------ | ------------------------ | -------------------------- | ---------------------------- | ------------------------- | ---------------------------- |
| [![appveyor][]][av-site] | [![tests][]][tests-site] | [![codefactor][]][cf-site] | [![codecov][]][codecov-link] | [![psgallery][]][ps-site] | [![license][]][license-link] |

[appveyor]: https://ci.appveyor.com/api/projects/status/github/pspete/IdentityCommand.SCA?branch=main&svg=true
[av-site]: https://ci.appveyor.com/project/pspete/IdentityCommand-SCA/branch/main
[psgallery]: https://img.shields.io/powershellgallery/v/IdentityCommand.SCA.svg
[ps-site]: https://www.powershellgallery.com/packages/IdentityCommand.SCA
[tests]: https://img.shields.io/appveyor/tests/pspete/IdentityCommand-SCA.svg
[tests-site]: https://ci.appveyor.com/project/pspete/IdentityCommand-SCA
[downloads]: https://img.shields.io/powershellgallery/dt/IdentityCommand.SCA.svg?color=blue
[cf-site]: https://www.codefactor.io/repository/github/pspete/IdentityCommand.SCA
[codefactor]: https://www.codefactor.io/repository/github/pspete/IdentityCommand.SCA/badge
[codecov]: https://codecov.io/gh/pspete/IdentityCommand.SCA/branch/main/graph/badge.svg
[codecov-link]: https://codecov.io/gh/pspete/IdentityCommand.SCA
[license]: https://img.shields.io/github/license/pspete/IdentityCommand.SCA.svg
[license-link]: https://github.com/pspete/IdentityCommand.SCA/blob/main/LICENSE

## Using the Module

The module requires authentication to the CyberArk Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.SCA`.

An overview of some of the features of the module are found in the below sections.

### SCA Authentication

The `Connect-SCATenant` command initialises the bearer token used for module operations against the SCA service.

If an Identity session already exists (established with the `IdentityCommand` module's `New-IDSession` or `New-IDPlatformToken`), it is used as-is:

```powershell
# Resolve the SCA API url automatically from the shared services subdomain
Connect-SCATenant -tenant_subdomain sometenant

# Or provide the SCA tenant url directly
Connect-SCATenant -tenant_url https://sometenant.sca.cyberark.cloud
```

Otherwise, provide a credential and `Connect-SCATenant` authenticates to CyberArk Identity for you - the Identity tenant url is discovered from the same subdomain / url:

```powershell
# Interactive user authentication (any MFA challenges are handled by IdentityCommand)
Connect-SCATenant -tenant_subdomain sometenant -Credential $Credential

# Non-interactive service user authentication via an OAuth platform token
Connect-SCATenant -tenant_subdomain sometenant -Credential $ServiceUserCredential -PlatformToken
```

### User Access Policies

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

### Requesting Access

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

### Managing Sessions

```powershell
# Every active session in the tenant (requires the CS Admin role)
Get-SCASession

# Your own sessions
Get-SCASession -userId my

# Revoke by session, or every session belonging to a user
Revoke-SCASession -sessionIds '1234abcd-12ab-34cd-56ef-1234567890ab'
Revoke-SCASession -userId my
```

### Cloud Scans & Jobs

Scans, discoveries, policy creation and web app creation are asynchronous, and return a job id which `Get-SCAJobStatus` reports on:

```powershell
# Scan every onboarded AWS account
Start-SCAScan -cloudProvider AWS -accountType All | Get-SCAJobStatus

# Scan specific accounts only
$Entities = New-SCAScanEntityDefinition -org_id '098765432109' -account_id '123456789012'
Start-SCAScan -cloudProvider AWS -accountType Specific -entityIds $Entities

# Discover the structure of a newly added account, then scan it
Start-SCADiscovery -csp AWS -organization_id '123457654321' -id '987654123456' -new_account $true
```

### Onboarding & Approvals

```powershell
# Create the web app users connect to a cloud environment through
New-SCAWebApp -appType 'AWS IAM' -appName 'SA AWS Account 1234567890' -workspaceId '1234567890'

# Configure how on-demand access requests are approved
Get-SCAOnDemandConfig
Set-SCAOnDemandConfig -ApprovalChannel 'In-platform'
```

### Troubleshooting

Most SCA endpoints accept a `debug` parameter which returns extended detail alongside an API error. There is no module parameter for it - PowerShell reserves `-Debug` - so commands calling an endpoint which supports it send `debug=true` whenever they are run with the common `-Debug` parameter:

```powershell
Get-SCAPolicy -policy_id aws_7eb12345-e678-1a23-b5d5-12e39c1455fa -Debug
```

`Get-SCAModuleData` returns the module's session data, including details of the last command sent and the last error received:

```powershell
Get-SCAModuleData
```

## Installation

### Prerequisites

- Requires PowerShell v5.1 or higher.
- The `IdentityCommand` module.

### Install Options

Install from the PowerShell Gallery:

```powershell
Install-Module -Name IdentityCommand.SCA -Scope CurrentUser
```

Or download the [latest release](https://github.com/pspete/IdentityCommand.SCA/releases), unblock and extract the archive, and copy the `IdentityCommand.SCA` folder into a path listed in `$env:PSModulePath`.

## Contributing

Want to contribute? Great! Please read the [Contribution Guidelines](CONTRIBUTING.md), and the [Code of Conduct](CODE_OF_CONDUCT.md).

## License

This project is [licensed under the MIT License](LICENSE).

![IdentityCommand.SCA][BottomLogo]

[BottomLogo]: /docs/media/images/IdentityCommand.SCA-Logo.png
