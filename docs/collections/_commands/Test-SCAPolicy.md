---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Test-SCAPolicy

## SYNOPSIS
Validates an SCA user access policy

## SYNTAX

```
Test-SCAPolicy [-policyId] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Triggers a validation process for a user access policy, confirming the cloud roles and identities it references can still be resolved.

The operation is asynchronous - the returned job ID can be passed to Get-SCAJobStatus.

## EXAMPLES

### Example 1
```powershell
Test-SCAPolicy -policyId aws_sso_1234abcd-123a-1ab2-a12b-12f1b179e053
```

Starts validation of the specified policy.

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

### -policyId
The unique ID of the policy.

```yaml
Type: String
Parameter Sets: (All)
Aliases: policy_id

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

## RELATED LINKS
