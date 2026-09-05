---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Connect-SCATenant

## SYNOPSIS
Connects to a Secure Cloud Access tenant

## SYNTAX

### Subdomain (Default)
```
Connect-SCATenant -tenant_subdomain <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### SubdomainSAML
```
Connect-SCATenant -tenant_subdomain <String> -SAMLResponse <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### SubdomainCredential
```
Connect-SCATenant -tenant_subdomain <String> -Credential <PSCredential> [-PlatformToken] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### URLSAML
```
Connect-SCATenant -tenant_url <String> -SAMLResponse <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### URLCredential
```
Connect-SCATenant -tenant_url <String> -Credential <PSCredential> [-PlatformToken] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### URL
```
Connect-SCATenant -tenant_url <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Makes the URL of a Secure Cloud Access tenant, and the details of an authenticated CyberArk Identity session, available to the other commands in the module.

An existing IdentityCommand session, created with New-IDSession or New-IDPlatformToken, is used when one is found. Otherwise, supply a credential or a SAML assertion and authentication is performed against the CyberArk Identity URL resolved from platform discovery.

## EXAMPLES

### Example 1
```powershell
Connect-SCATenant -tenant_subdomain sometenant
```

Resolves the SCA tenant URL for the sometenant subdomain, and uses the active IdentityCommand session.

### Example 2
```powershell
Connect-SCATenant -tenant_subdomain sometenant -Credential $Credential
```

Authenticates to CyberArk Identity as the supplied user, and connects to the SCA tenant.

### Example 3
```powershell
Connect-SCATenant -tenant_url https://sometenant.sca.cyberark.cloud -Credential $Credential -PlatformToken
```

Authenticates as a service user via New-IDPlatformToken, and connects to the specified SCA tenant.

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
The credential to authenticate to CyberArk Identity with, when no active IdentityCommand session is found.

```yaml
Type: PSCredential
Parameter Sets: SubdomainCredential, URLCredential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PlatformToken
Specify to authenticate as a service user via New-IDPlatformToken, instead of the interactive New-IDSession.

```yaml
Type: SwitchParameter
Parameter Sets: SubdomainCredential, URLCredential
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SAMLResponse
The SAML assertion to authenticate to CyberArk Identity with, when no active IdentityCommand session is found.

```yaml
Type: String
Parameter Sets: SubdomainSAML, URLSAML
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tenant_subdomain
The ISPSS shared services subdomain of the tenant to connect to.

```yaml
Type: String
Parameter Sets: Subdomain, SubdomainSAML, SubdomainCredential
Aliases: subdomain

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -tenant_url
The URL of the SCA tenant to connect to.

```yaml
Type: String
Parameter Sets: URLSAML, URLCredential, URL
Aliases: SCA_url

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
