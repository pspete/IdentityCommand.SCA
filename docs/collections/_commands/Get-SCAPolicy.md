---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Get-SCAPolicy

## SYNOPSIS
Gets details of SCA user access policies

## SYNTAX

### List (Default)
```
Get-SCAPolicy [-status <String>] [-free_text <String>] [-cloud_provider <String>] [<CommonParameters>]
```

### ById
```
Get-SCAPolicy -policy_id <String> [<CommonParameters>]
```

## DESCRIPTION
Returns a list of the user access policies defined in Secure Cloud Access, optionally filtered by status, cloud provider or free text, or the full details of a single policy.

Version 2.0 of the Policies API is used.

## EXAMPLES

### Example 1
```powershell
Get-SCAPolicy
```

Gets a list of all policies.

### Example 2
```powershell
Get-SCAPolicy -status Active -cloud_provider AWS
```

Gets a list of the active policies which apply to AWS.

### Example 3
```powershell
Get-SCAPolicy -policy_id aws_7eb12345-e678-1a23-b5d5-12e39c1455fa
```

Gets the full details of a specific policy.

## PARAMETERS

### -cloud_provider
Filter on policies which apply to a specific cloud provider.

Supported values: AWS, GCP, AZURE, AWS_IDC, AZURE_ENTRA_ID.

```yaml
Type: String
Parameter Sets: List
Aliases:
Accepted values: AWS, GCP, AZURE, AWS_IDC, AZURE_ENTRA_ID

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -free_text
Search for free text in the name, description, entity name, organization ID, cloud provider, status and account name of a policy.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -policy_id
The unique ID of the policy.

```yaml
Type: String
Parameter Sets: ById
Aliases: policyId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -status
Filter on policies with a specific status.

Supported values: Active, Expired, Error, Validating.

```yaml
Type: String
Parameter Sets: List
Aliases:
Accepted values: Active, Expired, Error, Validating

Required: False
Position: Named
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
