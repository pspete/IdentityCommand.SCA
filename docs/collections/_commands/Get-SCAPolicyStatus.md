---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Get-SCAPolicyStatus

## SYNOPSIS
Gets the status of an SCA user access policy

## SYNTAX

```
Get-SCAPolicyStatus [-policy_id] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the status of a policy.

The API reports the status as a bare integer; the returned object pairs that value with its name and a description of what it means:

- 1 - Active - The policy is active
- 3 - Expired - The policy has expired
- 4 - Error - There is an error in the policy
- 5 - Warning - The policy is active, with a warning
- 6 - Validating - The policy is currently being validated

A status value this module has no definition for is returned as-is, with no name or description.

Useful for following a policy through validation after it has been created or updated.

## EXAMPLES

### Example 1
```powershell
Get-SCAPolicyStatus -policy_id aws_7eb12345-e678-1a23-b5d5-12e39c1455fa

policyId    : aws_7eb12345-e678-1a23-b5d5-12e39c1455fa
status      : 1
statusName  : Active
description : The policy is active
```

Gets the status of the specified policy.

### Example 2
```powershell
Get-SCAPolicy | Get-SCAPolicyStatus | Where-Object { $PSItem.statusName -eq 'Error' }
```

Reports every policy which is in an error state.

## PARAMETERS

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

### IdCmd.SCA.Policy.Status
## NOTES

Vendor documentation states the API which this command uses will be deprecated in the near future.

## RELATED LINKS
