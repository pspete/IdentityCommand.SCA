---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Revoke-SCASession

## SYNOPSIS
Revokes active SCA sessions

## SYNTAX

### BySessionId (Default)
```
Revoke-SCASession -sessionIds <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByUser
```
Revoke-SCASession -userId <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Revokes elevated access sessions, either by session ID or for every session belonging to a user.

Revoking the sessions of any user requires the CS Admin role; without it, only your own sessions can be revoked.

## EXAMPLES

### Example 1
```powershell
Revoke-SCASession -sessionIds '1234abcd-12ab-34cd-56ef-1234567890ab'
```

Revokes a single session.

### Example 2
```powershell
Get-SCASession -csp AWS | Revoke-SCASession
```

Revokes every active AWS session.

### Example 3
```powershell
Revoke-SCASession -userId my
```

Revokes all of your own active sessions.

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

### -sessionIds
The IDs of the sessions to revoke.

```yaml
Type: String[]
Parameter Sets: BySessionId
Aliases: sessionId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -userId
The user whose sessions to act on. Specify "my" or the user's own ID to act on your own sessions.

```yaml
Type: String
Parameter Sets: ByUser
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

### System.String[]

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
