---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Set-SCAPolicy

## SYNOPSIS
Updates an SCA user access policy

## SYNTAX

```
Set-SCAPolicy [-policy_id] <String> [[-name] <String>] [[-description] <String>] [[-startDate] <DateTime>]
 [[-endDate] <DateTime>] [[-roles] <PSObject[]>] [[-identities] <PSObject[]>] [[-accessRules] <PSObject>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates an existing user access policy.

The current policy is queried first, and any property which is not supplied keeps the value it already has. The cloud provider a policy applies to cannot be changed.

## EXAMPLES

### Example 1
```powershell
Set-SCAPolicy -policy_id aws_7eb12345-e678-1a23-b5d5-12e39c1455fa -description 'End-of-year calculations'
```

Updates the description of the policy, leaving every other property unchanged.

### Example 2
```powershell
$Roles = New-SCAPolicyRoleDefinition -entityId 'arn:aws:iam::123451234567:role/examplerole' -entitySourceId '123451234567'
$Roles = New-SCAPolicyRoleDefinition -Definition $Roles -entityId 'arn:aws:iam::123451234567:role/otherrole' -entitySourceId '123451234567'

Set-SCAPolicy -policy_id aws_7eb12345-e678-1a23-b5d5-12e39c1455fa -roles $Roles
```

Replaces the roles granted by the policy with the two roles defined.

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

### -accessRules
Accepts object output from New-SCAPolicyAccessRuleDefinition.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -description
The description of the policy. Up to 200 characters.

The API accepts the same characters as -name, and additionally $ ] ^ { }.
Notably, ( ) & ' " # % and * are not accepted.

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

### -endDate
The date and time when the policy expires. Sent to the API as a UTC ISO 8601 value.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -identities
Accepts object output from New-SCAPolicyIdentityDefinition.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -name
The name of the policy. 1 to 200 characters.

The API accepts letters, digits, spaces and the characters ! + , - . / : ; < = > ? @ [ \ _ only.
Notably, ( ) & ' " # % and * are not accepted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### -roles
Accepts object output from New-SCAPolicyRoleDefinition.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -startDate
The date and time when the policy becomes active. Sent to the API as a UTC ISO 8601 value.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.DateTime

### System.Management.Automation.PSObject[]

### System.Management.Automation.PSObject

## OUTPUTS

### System.Object
## NOTES

Vendor documentation states the API which this command uses will be deprecated in the near future.

## RELATED LINKS
