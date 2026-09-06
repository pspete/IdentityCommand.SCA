---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Request-SCAAccess

## SYNOPSIS
Elevates access to cloud targets

## SYNTAX

```
Request-SCAAccess [-csp] <String> [-targets] <PSObject[]> [[-organizationId] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Requests just-in-time elevated access to one or more targets, each identifying a workspace and the role to be assumed in it.

The targets are built with New-SCAAccessTargetDefinition, and the eligible combinations can be listed with Get-SCAEligibleTarget. Access credentials for each successful target are returned.

## EXAMPLES

### Example 1
```powershell
$Targets = New-SCAAccessTargetDefinition -workspaceId '123451234567' -roleName examplerole

Request-SCAAccess -csp AWS -organizationId '098765432109' -targets $Targets
```

Elevates access to an AWS IAM role in an account within an AWS organization.

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

### -csp
The cloud provider hosting the targets to elevate access to.

Supported values: AWS, AZURE, GCP.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: AWS, AZURE, GCP

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -organizationId
The ID of the organization the targets belong to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -targets
Accepts object output from New-SCAAccessTargetDefinition. Up to 5 targets can be requested in a single request, and all must belong to the same organization.

The API limits this further depending on the target: a single target only, for a standalone AWS account or an AWS account in an organization; up to 5 for Google Cloud folders or projects, or Azure subscriptions, resource groups or resources; up to 3 for Microsoft Entra ID. The higher limits apply only where connection with multiple roles is enabled.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Management.Automation.PSObject[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
