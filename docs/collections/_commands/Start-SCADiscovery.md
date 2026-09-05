---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Start-SCADiscovery

## SYNOPSIS
Discovers updates to an onboarded workspace

## SYNTAX

```
Start-SCADiscovery [-csp] <String> [-organization_id] <String> [-id] <String> [[-new_account] <Boolean>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Starts a discovery of the structure of an onboarded workspace. Once discovery completes, the workspace is automatically scanned for roles, permission sets and resources.

To scan an onboarded workspace without first discovering its structure, use Start-SCAScan.

The operation is asynchronous - the returned job ID can be passed to Get-SCAJobStatus.

## EXAMPLES

### Example 1
```powershell
Start-SCADiscovery -csp AWS -organization_id '123457654321' -id '987654123456' -new_account $true
```

Discovers a newly added AWS account within an AWS organization.

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
The cloud environment to run the discovery in.

Supported values: AWS, GCP, AZURE.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: AWS, GCP, AZURE

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -id
The ID of the account, project or subscription to discover.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -new_account
Specify $true when the workspace has not previously been discovered.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -organization_id
The ID of the organization the workspace belongs to.

```yaml
Type: String
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

### System.Boolean

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
