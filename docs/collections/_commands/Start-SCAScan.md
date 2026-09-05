---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Start-SCAScan

## SYNOPSIS
Scans onboarded workspaces for roles and resources

## SYNTAX

```
Start-SCAScan [-cloudProvider] <String> [-accountType] <String> [[-entityIds] <PSObject[]>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Starts a scan of the cloud roles and resources in onboarded workspaces, either across every onboarded account or across specific accounts only.

To discover the structure of a workspace before scanning it, use Start-SCADiscovery.

The operation is asynchronous - the returned job ID can be passed to Get-SCAJobStatus.

## EXAMPLES

### Example 1
```powershell
Start-SCAScan -cloudProvider AWS -accountType All
```

Scans every onboarded AWS account.

### Example 2
```powershell
$Entities = New-SCAScanEntityDefinition -org_id '098765432109' -account_id '123456789012'

Start-SCAScan -cloudProvider AWS -accountType Specific -entityIds $Entities
```

Scans a single AWS account within an AWS organization.

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

### -accountType
The scope of the scan.

All: scan all onboarded accounts.
Specific: scan only the accounts identified by entityIds.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: All, Specific

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cloudProvider
The cloud environment the scan applies to.

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

### -entityIds
Accepts object output from New-SCAScanEntityDefinition.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
