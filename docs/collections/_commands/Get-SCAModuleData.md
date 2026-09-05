---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Get-SCAModuleData

## SYNOPSIS
Gets the module session data

## SYNTAX

```
Get-SCAModuleData [<CommonParameters>]
```

## DESCRIPTION
Returns a copy of the data held in the module scope for the current session - the tenant URL, the authenticated user, and details of the last command sent to the API.

The data is a copy; changing it has no effect on the session.

## EXAMPLES

### Example 1
```powershell
Get-SCAModuleData
```

Gets the session data for the current module session.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
