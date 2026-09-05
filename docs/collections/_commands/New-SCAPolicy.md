---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# New-SCAPolicy

## SYNOPSIS
Creates an SCA user access policy

## SYNTAX

```
New-SCAPolicy [-csp] <String> [-name] <String> [[-description] <String>] [[-startDate] <DateTime>]
 [[-endDate] <DateTime>] [-roles] <PSObject[]> [-identities] <PSObject[]> [[-accessRules] <PSObject>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a user access policy, granting the specified identities just-in-time access to the specified cloud roles.

The roles, identities and access rules are built with New-SCAPolicyRoleDefinition, New-SCAPolicyIdentityDefinition and New-SCAPolicyAccessRuleDefinition.

The operation is asynchronous - the returned job ID can be passed to Get-SCAJobStatus.

## EXAMPLES

### Example 1
```powershell
$Roles = New-SCAPolicyRoleDefinition -entityId 'arn:aws:iam::123451234567:role/examplerole' -entitySourceId '123451234567'
$Identities = New-SCAPolicyIdentityDefinition -entityName 'John.D@company.com' -entitySourceId 'A1B2C3D4-1AB2-465F-AB03-12345D55B05E' -entityClass user
$AccessRules = New-SCAPolicyAccessRuleDefinition -days Monday, Tuesday -fromTime '08:00' -toTime '17:00' -maxSessionDuration 2 -timeZone 'Europe/London'

New-SCAPolicy -csp AWS -name finance -description 'End-of-year calculations' -roles $Roles -identities $Identities -accessRules $AccessRules
```

Creates a policy granting John.D access to an AWS IAM role on Mondays and Tuesdays, between 08:00 and 17:00 UK time, for up to 2 hours at a time.

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

### -csp
The cloud environment the policy applies to.

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

### -description
The description of the policy.

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

Required: True
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -name
The name of the policy.

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

### -roles
Accepts object output from New-SCAPolicyRoleDefinition.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: True
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

## RELATED LINKS
