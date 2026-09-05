---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# New-SCAPolicyAccessRuleDefinition

## SYNOPSIS
Defines the access rules for an SCA user access policy

## SYNTAX

```
New-SCAPolicyAccessRuleDefinition [-days] <String[]> [[-fromTime] <String>] [[-toTime] <String>]
 [-maxSessionDuration] <Int32> [-timeZone] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns an access rule definition object for use with the -accessRules parameter of New-SCAPolicy and Set-SCAPolicy, specifying when the policy is active and how long a session may last.

A policy has a single set of access rules, so unlike the role and identity definitions there is nothing to chain onto.

## EXAMPLES

### Example 1
```powershell
New-SCAPolicyAccessRuleDefinition -days Monday, Tuesday, Wednesday, Thursday, Friday -fromTime '08:00' -toTime '17:00' -maxSessionDuration 2 -timeZone 'Europe/London'
```

Defines access on weekdays, between 08:00 and 17:00 UK time, for up to 2 hours at a time.

### Example 2
```powershell
$AccessRules = New-SCAPolicyAccessRuleDefinition -days Saturday, Sunday -maxSessionDuration 8 -timeZone 'Europe/London'

New-SCAPolicy -csp AWS -name weekend-support -roles $Roles -identities $Identities -accessRules $AccessRules
```

Defines all-day weekend access, for up to 8 hours at a time, and creates a policy using it.

## PARAMETERS

### -days
The days of the week the policy is active on.

Supported values: Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -fromTime
The time of day the policy becomes active, in 24 hour hh:mm or hh:mm:ss format.

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

### -maxSessionDuration
The maximum length, in hours, of a user session. Must not exceed the duration defined on the cloud role.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -timeZone
A time zone identifier which the access rule times are evaluated against, for example Europe/London.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -toTime
The time of day the policy becomes inactive, in 24 hour hh:mm or hh:mm:ss format.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

### System.String

### System.Int32

## OUTPUTS

### IdCmd.SCA.Definition.Policy.AccessRule

## NOTES

## RELATED LINKS
