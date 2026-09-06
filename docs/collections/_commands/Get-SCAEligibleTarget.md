---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Get-SCAEligibleTarget

## SYNOPSIS
Gets the targets you are eligible to access

## SYNTAX

```
Get-SCAEligibleTarget [-csp] <String> [[-limit] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Returns the workspaces and roles in a cloud provider which you are eligible to request just-in-time access to, along with the access window and whether approval is required.

Results are automatically paginated - all matching records are returned regardless of how many pages the API splits them across.

## EXAMPLES

### Example 1
```powershell
Get-SCAEligibleTarget -csp AWS
```

Gets every AWS target you are eligible to access.

### Example 2
```powershell
Get-SCAEligibleTarget -csp AZURE -limit 100
```

Gets every Azure target you are eligible to access, requesting 100 records per page.

## PARAMETERS

### -csp
The cloud provider to list the targets you are eligible to access for.

Supported values: AWS, AZURE, GCP.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: AWS, AZURE, GCP

Required: True
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

Each returned target reports the workspace (workspaceId, workspaceName), the role you are eligible to use (role.id, role.name), and the organization the workspace belongs to (organizationId).

workspaceType is ACCOUNT for AWS, and one of DIRECTORY, MANAGEMENT_GROUP, SUBSCRIPTION, RESOURCE_GROUP or RESOURCE for Azure.

accessApproval.status reports whether a request is needed before connecting - REQUIRED, PENDING or APPROVED.

accessWindow reports when access is allowed - RECURRING where a policy defines a window, UNLIMITED where access is allowed at any time, or FIXED for the window granted by an approved request.

## RELATED LINKS
