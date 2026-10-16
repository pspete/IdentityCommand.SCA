---
title: Getting Started
subtitle: Install IdentityCommand.SCA and connect to Secure Cloud Access
---

## Prerequisites

- Requires PowerShell v5.1 or higher.
- The `IdentityCommand` module.

## Install Options

Install from the PowerShell Gallery:

```powershell
Install-Module -Name IdentityCommand.SCA -Scope CurrentUser
```

Or download the [latest release](https://github.com/pspete/IdentityCommand.SCA/releases), unblock and extract the archive, and copy the `IdentityCommand.SCA` folder into a path listed in `$env:PSModulePath`.

## Authentication

The module requires authentication to the CyberArk Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.SCA`.

An overview of some of the features of the module are found in the below sections.


Authenticate with the `IdentityCommand` module, using `New-IDSession` (interactive user, including any MFA challenges) or `New-IDPlatformToken` (non-interactive service user). Commands find the SCA service url from the Identity session on first use - no separate connection step is needed:

```powershell
# Interactive user authentication
New-IDSession -tenant_url https://abc1234.id.cyberark.cloud -Credential $Credential

# Or non-interactive service user authentication via an OAuth platform token
New-IDPlatformToken -tenant_url https://abc1234.id.cyberark.cloud -Credential $ServiceUserCredential

Get-SCAPolicy
```

Commands follow the current Identity session: a later `New-IDSession` or `New-IDPlatformToken` is used by the next command, and after `Close-IDSession` commands fail until you authenticate again.
