---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Get-SCAEligibleGroup

## SYNOPSIS
Gets the groups you are eligible to join

## SYNTAX

```
Get-SCAEligibleGroup [[-csp] <String>] [[-limit] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Returns the groups for which you are eligible to request just-in-time membership.

Results are automatically paginated - all matching records are returned regardless of how many pages the API splits them across.

## EXAMPLES

### Example 1
```powershell
Get-SCAEligibleGroup
```

Gets every group you are eligible to request membership of.

## PARAMETERS

### -csp
The cloud provider hosting the groups. Only AZURE is supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: AZURE

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -limit
The maximum number of records to return in a single response. All pages of results are returned regardless of the value specified.

```yaml
Type: Int32
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

### System.Int32

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
