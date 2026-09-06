---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Get-SCASession

## SYNOPSIS
Gets active SCA sessions

## SYNTAX

### All (Default)
```
Get-SCASession [-csp <String>] [-limit <Int32>] [<CommonParameters>]
```

### ByUser
```
Get-SCASession -userId <String> [-csp <String>] [-limit <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Returns the active elevated access sessions, either across the tenant or for a specific user.

Listing the sessions of any user requires the CS Admin role; without it, only your own sessions can be listed. Results are automatically paginated - all matching records are returned regardless of how many pages the API splits them across.

## EXAMPLES

### Example 1
```powershell
Get-SCASession
```

Gets every active session in the tenant.

### Example 2
```powershell
Get-SCASession -csp AWS
```

Gets every active AWS session in the tenant.

### Example 3
```powershell
Get-SCASession -userId my
```

Gets your own active sessions.

## PARAMETERS

### -csp
The cloud provider to list active sessions for.

Supported values: AWS, AZURE, GCP.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: AWS, AZURE, GCP

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -limit
The maximum number of active sessions to return in a single response, from 1 to 50. All pages of results are returned regardless of the value specified.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
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

### System.String

### System.Int32

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
