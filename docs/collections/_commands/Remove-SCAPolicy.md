---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Remove-SCAPolicy

## SYNOPSIS
Removes an SCA user access policy

## SYNTAX

```
Remove-SCAPolicy [-policy_id] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Moves a user access policy to archive mode, revoking the just-in-time access it granted.

## EXAMPLES

### Example 1
```powershell
Remove-SCAPolicy -policy_id aws_7eb12345-e678-1a23-b5d5-12e39c1455fa
```

Removes the specified policy.

### Example 2
```powershell
Get-SCAPolicy -status Expired | Remove-SCAPolicy
```

Removes every expired policy.

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

### -policy_id
The unique ID of the policy.

```yaml
Type: String
Parameter Sets: (All)
Aliases: policyId

Required: True
Position: 0
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

Vendor documentation states the API which this command uses will be deprecated in the near future.

## RELATED LINKS
