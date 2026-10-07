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

