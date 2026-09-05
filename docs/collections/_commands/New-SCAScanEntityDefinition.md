---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# New-SCAScanEntityDefinition

## SYNOPSIS
Defines a cloud entity to scan

## SYNTAX

```
New-SCAScanEntityDefinition [-account_id] <String> [[-org_id] <String>] [[-Definition] <PSObject[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns an entity definition object for use with the -entityIds parameter of Start-SCAScan, identifying a specific account, project or subscription to scan.

Pass the output of a previous call as -Definition to scan several entities in one request.

## EXAMPLES

### Example 1
```powershell
New-SCAScanEntityDefinition -account_id '123456789012'
```

Defines a standalone AWS account to scan.

### Example 2
```powershell
$Entities = New-SCAScanEntityDefinition -org_id '098765432109' -account_id '123456789012'
$Entities = New-SCAScanEntityDefinition -Definition $Entities -org_id '098765432109' -account_id '210987654321'

Start-SCAScan -cloudProvider AWS -accountType Specific -entityIds $Entities
```

Chains two accounts in an AWS organization together, and scans both.

## PARAMETERS

### -Definition
Accepts previous output from New-SCAScanEntityDefinition, to which this entity is appended.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -account_id
The ID of the account, project or subscription to scan.

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

### -org_id
The ID of the organization the account belongs to. Not required for a standalone AWS account.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### IdCmd.SCA.Definition.Scan.EntityId

## NOTES

## RELATED LINKS
