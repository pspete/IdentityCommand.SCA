---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Request-SCAGroupMembership

## SYNOPSIS
Requests just-in-time membership of groups

## SYNTAX

```
Request-SCAGroupMembership [-directoryId] <String> [-groupId] <String[]> [[-csp] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Requests just-in-time membership of one or more groups hosted in the specified directory.

The groups you are eligible to join can be listed with Get-SCAEligibleGroup.

## EXAMPLES

### Example 1
```powershell
Request-SCAGroupMembership -directoryId 'abcde123-abcd-123a-abcd-a1b23456cd7e' -groupId '1234abcd-12ab-34cd-56ef-1234567890ab'
```

Requests just-in-time membership of a single group.

### Example 2
```powershell
Get-SCAEligibleGroup | Request-SCAGroupMembership
```

Requests just-in-time membership of every group you are eligible to join.

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
The cloud provider hosting the groups. Only AZURE is supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: AZURE

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -directoryId
The ID of the directory hosting the groups.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -groupId
The IDs of the groups to request just-in-time membership of.

```yaml
Type: String[]
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

### System.String[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
