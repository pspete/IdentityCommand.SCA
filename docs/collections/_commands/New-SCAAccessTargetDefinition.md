---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# New-SCAAccessTargetDefinition

## SYNOPSIS
Defines a target to elevate access to

## SYNTAX

### ByRoleId (Default)
```
New-SCAAccessTargetDefinition -workspaceId <String> -roleId <String> [-Definition <PSObject[]>]
 [<CommonParameters>]
```

### ByRoleName
```
New-SCAAccessTargetDefinition -workspaceId <String> -roleName <String> [-Definition <PSObject[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns a target definition object for use with the -targets parameter of Request-SCAAccess. A target pairs a workspace with the role to be assumed in it, identified either by role ID or by role name.

Pass the output of a previous call as -Definition to elevate access to several targets in one request.

## EXAMPLES

### Example 1
```powershell
New-SCAAccessTargetDefinition -workspaceId '123451234567' -roleName examplerole
```

Defines a single target, identifying the role by name.

### Example 2
```powershell
$Targets = New-SCAAccessTargetDefinition -workspaceId '123451234567' -roleName examplerole
$Targets = New-SCAAccessTargetDefinition -Definition $Targets -workspaceId '210987654321' -roleId 'arn:aws:iam::210987654321:role/otherrole'

Request-SCAAccess -csp AWS -organizationId '098765432109' -targets $Targets
```

Chains two targets together, and elevates access to both in a single request.

### Example 3
```powershell
Get-SCAEligibleTarget -csp AWS | ForEach-Object { New-SCAAccessTargetDefinition -workspaceId $PSItem.workspaceId -roleId $PSItem.role.id }
```

Defines a target for every AWS target you are eligible to access.

## PARAMETERS

### -Definition
Accepts previous output from New-SCAAccessTargetDefinition, to which this target is appended.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -roleId
The ID of the role to request access with.

```yaml
Type: String
Parameter Sets: ByRoleId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -roleName
The name of the role to request access with.

```yaml
Type: String
Parameter Sets: ByRoleName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -workspaceId
The ID of the workspace to request access to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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

### IdCmd.SCA.Definition.Access.Target

## NOTES

## RELATED LINKS
