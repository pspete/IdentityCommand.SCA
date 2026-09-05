---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Get-SCAOnDemandConfig

## SYNOPSIS
Gets the on-demand approval channel configuration

## SYNTAX

```
Get-SCAOnDemandConfig [<CommonParameters>]
```

## DESCRIPTION
Returns the approval channel currently configured to handle on-demand access requests - either the Idira in-platform channel, or an external channel such as ServiceNow or Slack.

## EXAMPLES

### Example 1
```powershell
Get-SCAOnDemandConfig
```

Gets the configured approval channel.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
