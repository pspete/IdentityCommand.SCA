---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# New-SCAPolicyIdentityDefinition

## SYNOPSIS
Defines an identity for an SCA user access policy

## SYNTAX

```
New-SCAPolicyIdentityDefinition [-entityName] <String> [-entitySourceId] <String> [-entityClass] <String>
 [[-Definition] <PSObject[]>] [<CommonParameters>]
```

## DESCRIPTION
Returns an identity definition object for use with the -identities parameter of New-SCAPolicy and Set-SCAPolicy.

Pass the output of a previous call as -Definition to add further identities to the same policy.

## EXAMPLES

### Example 1
```powershell
New-SCAPolicyIdentityDefinition -entityName 'John.D@company.com' -entitySourceId 'A1B2C3D4-1AB2-465F-AB03-12345D55B05E' -entityClass user
```

Defines a single user identity, identified by its principal name and the ID of the directory service holding it.

### Example 2
```powershell
$Identities = New-SCAPolicyIdentityDefinition -entityName 'John.D@company.com' -entitySourceId 'A1B2C3D4-1AB2-465F-AB03-12345D55B05E' -entityClass user
$Identities = New-SCAPolicyIdentityDefinition -Definition $Identities -entityName 'CloudAdmins' -entitySourceId 'A1B2C3D4-1AB2-465F-AB03-12345D55B05E' -entityClass group

New-SCAPolicy -csp AWS -name finance -roles $Roles -identities $Identities
```

Chains a user and a group definition together, and creates a policy granting access to both.

## PARAMETERS

### -Definition
Accepts previous output from New-SCAPolicyIdentityDefinition, to which this identity is appended.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -entityClass
The type of the identity.

Supported values: user, role, group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: user, role, group

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -entityName
The full user principal name of the identity, for example user@domain.com.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### IdCmd.SCA.Definition.Policy.Identity

## NOTES

## RELATED LINKS
