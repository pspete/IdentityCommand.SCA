---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# New-SCAPolicyRoleDefinition

## SYNOPSIS
Defines a cloud role for an SCA user access policy

## SYNTAX

```
New-SCAPolicyRoleDefinition [-entityId] <String> [-entitySourceId] <String> [[-workspaceType] <String>]
 [[-organizationId] <String>] [[-Definition] <PSObject[]>] [<CommonParameters>]
```

## DESCRIPTION
Returns a role definition object for use with the -roles parameter of New-SCAPolicy and Set-SCAPolicy.

Pass the output of a previous call as -Definition to add further roles to the same policy.

## EXAMPLES

### Example 1
```powershell
New-SCAPolicyRoleDefinition -entityId 'arn:aws:iam::123451234567:role/examplerole' -entitySourceId '123451234567'
```

Defines a single AWS IAM role, identified by its ARN and the ID of the account hosting it.

### Example 2
```powershell
$Roles = New-SCAPolicyRoleDefinition -entityId 'arn:aws:iam::123451234567:role/examplerole' -entitySourceId '123451234567'
$Roles = New-SCAPolicyRoleDefinition -Definition $Roles -entityId 'arn:aws:iam::123451234567:role/otherrole' -entitySourceId '123451234567' -organizationId '098765432109'

New-SCAPolicy -csp AWS -name finance -roles $Roles -identities $Identities
```

Chains two role definitions together, and creates a policy granting access to both.

### Example 3
```powershell
New-SCAPolicyRoleDefinition -entityId 'projects/dev/roles/cloudsql.client' -entitySourceId 'cybrsca-dev' -workspaceType project
```

Defines a Google Cloud role applied at project scope.

## PARAMETERS

### -Definition
Accepts previous output from New-SCAPolicyRoleDefinition, to which this role is appended.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -entityId
The cloud role to grant access to.

AWS: the IAM role ARN, or the AWS IAM Identity Center permission set.
Azure resource: the path of the roleDefinition in Azure.
Azure - Microsoft Entra ID: the unique identifier of the cloud role.
Google Cloud: the cloud role name and hierarchy structure.

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

### -entitySourceId
The source of the cloud role.

AWS: the account ID associated with the role.
Azure resource: the scope the role is applied at, provided as a path.
Azure - Microsoft Entra ID: the Azure tenant ID.
Google Cloud: the ID of the source organization, folder or project.

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

### -organizationId
The organization the workspace belongs to.

AWS: the management account ID (required only for AWS organizations).
Azure - Microsoft Entra ID: the Azure tenant ID.
Google Cloud: the Google Cloud organization ID.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -workspaceType
The type of workspace the role applies to.

AWS: account (required only for AWS IAM Identity Center).
Azure: directory, management_group, subscription, resource_group or resource.
Google Cloud: gcp_organization, folder or project.

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

### System.String

## OUTPUTS

### IdCmd.SCA.Definition.Policy.Role

## NOTES

## RELATED LINKS
